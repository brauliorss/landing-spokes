# Despliegue de MOP en Azure Cloud Shell

Usar PowerShell dentro de Azure Cloud Shell. Las rutas usan `/` porque Cloud Shell se ejecuta en Linux. Ejecutar las líneas por separado y detenerse ante cualquier error. No ejecutar el despliegue hasta completar los parámetros y revisar la vista previa.

## 1. Confirmar el destino

Solicitar y confirmar la suscripción de producción de MOP, el grupo de recursos nuevo, el client ID del registro Entra, UserDept y el rango VNet `/24` asignado por IPAM. No usar los valores de Smart Review o Análisis DEC.

```powershell
$MopSubscriptionId = Read-Host "ID de suscripción de MOP"
$MopResourceGroup = Read-Host "Grupo de recursos de MOP"
az account set --subscription $MopSubscriptionId
az account show --query "{Suscripcion:name,ID:id,Tenant:tenantId}" --output table
az group show --name $MopResourceGroup --query "{Nombre:name,Ubicacion:location}" --output table
az resource list --resource-group $MopResourceGroup --query "[].{Nombre:name,Tipo:type}" --output table
```

No continuar si no es el tenant y destino aprobados, si el grupo no existe o si contiene recursos que deban preservarse sin revisión. La plantilla no crea el grupo. No desplegar sobre `RG-POC-PreMop-CR`.

En el portal, comprobar cuota y capacidad de **App Service Linux P1v4 en East US, sin redundancia zonal**. MOP requiere inicialmente una instancia. No es cuota de Azure Compute. Un valor disponible en el portal no garantiza que el proveedor permita crear el plan; si hay discrepancia, solicitar revisión a soporte.

## 2. Obtener el código publicado

En una carpeta nueva:

```powershell
git clone --branch mop-spoke --single-branch https://github.com/lab-innov/landing-spokes.git landing-spokes-mop
Set-Location "./landing-spokes-mop"
git branch --show-current
git log -1 --oneline
```

Si ya existe esa carpeta, no sobrescribirla: revisar `git status` y conservar los parámetros antes de actualizar con `git pull --ff-only`. Para un repositorio privado, usar la autenticación corporativa aprobada; no pegar tokens en comandos o mensajes.

## 3. Preparar los parámetros

Solo si todavía no existe el archivo local:

```powershell
Copy-Item "./environments/dev.example.bicepparam" "./environments/prod.bicepparam" -Confirm
code "./environments/prod.bicepparam"
```

También puede abrirse desde el editor de Cloud Shell. Sustituir todos los marcadores `PENDIENTE`.

| Parámetro | Qué completar |
| --- | --- |
| Nombres de Function, plan, Storage, Cosmos y cuentas IA | Nombres nuevos de MOP aprobados; los Storage usan solamente minúsculas y números, hasta 24 caracteres |
| `vnetName`, `vnetAddressPrefixes` | Nombre de la VNet y rango `/24` reservado exclusivamente para MOP |
| `subnetPrefixes` | Subred de endpoints `/27` y subred de integración `/26`, alineadas, dentro de la VNet y sin solaparse |
| `privateDnsZoneResourceIds` | Los siete IDs completos de zonas privadas: Blob, Queue, Table, Azure Websites, Cosmos SQL, Cognitive Services y OpenAI |
| `authenticationClientId` | Application/client ID del registro Entra de MOP, no su object ID |
| `tenantId` | Por defecto se utiliza el tenant de la suscripción seleccionada; verificar que coincide con el registro Entra |
| `tags.UserDept` | Área funcional de MOP; `OpsDept` es `DTI` |
| `siemAuthorizationRuleId` | ID de regla del **namespace** Event Hub autorizado; no regla de un Event Hub individual ni clave secreta |
| `siemEventHubName` | Nombre del Event Hub corporativo aprobado para MOP |

Los IDs de DNS/Event Hub pueden corresponder a servicios centrales, pero Operaciones debe confirmar su uso y permisos para MOP. No se incluyen secretos ni datos reales del entorno en Git.

Para la creación inicial, mantener:

```bicep
param provisionNetwork = true
param activateFunctionApp = false
param models = []
param modelsApproved = false
param batchEnabled = false
param dynatraceVerified = false
param hostUsesDurableStorage = true
```

Mantener en `false` los demás controles de verificación y dejar vacías las listas de clientes, operadores, identidades e IP reales hasta disponer de los datos aprobados. No marcar controles como verificados solo para superar una validación.

No se requiere Log Analytics, Action Group ni ID de tabla de rutas. Dynatrace se integra por separado. Defender corporativo y análisis de malware deben comprobarse antes de activar.

## 4. Compilar y comprobar

```powershell
az bicep version
az bicep build --file "./infra/main.bicep" --outfile "./infra/main.json"
az bicep lint --file "./infra/main.bicep"
az bicep build-params --file "./environments/prod.bicepparam" --outfile "./environments/prod.parameters.json"
python "./scripts/check_parameters.py" "./environments/prod.parameters.json"
```

Si el comprobador detecta marcadores o datos incorrectos, corregir el `.bicepparam` y volver a compilar los parámetros. No reutilizar JSON generado antes de una modificación.

```powershell
az deployment group validate --subscription $MopSubscriptionId --resource-group $MopResourceGroup --template-file "./infra/main.json" --parameters '@./environments/prod.parameters.json' --mode Incremental
az deployment group what-if --subscription $MopSubscriptionId --resource-group $MopResourceGroup --template-file "./infra/main.json" --parameters '@./environments/prod.parameters.json' --mode Incremental --no-pretty-print --output json > "$HOME/mop-whatif.json"
```

Descargar `mop-whatif.json` mediante Manage files → Download y revisar el archivo completo. No aceptar eliminaciones, acceso público ni modificaciones no previstas. Las asignaciones de roles pueden aparecer como no evaluables porque dependen de una identidad todavía no creada; revisar sus ámbitos y permisos. La compilación y el what-if no garantizan cuota, capacidad ni éxito del despliegue.

## 5. Crear únicamente después de revisar

```powershell
az deployment group create --subscription $MopSubscriptionId --name "mop-fundacion-01" --resource-group $MopResourceGroup --template-file "./infra/main.json" --parameters '@./environments/prod.parameters.json' --mode Incremental --query "properties.provisioningState" --output tsv
```

Esperar `Succeeded`. Si falla, conservar los recursos y recuperar el error completo; no repetir automáticamente ni usar modo `Complete`.

```powershell
az deployment group show --subscription $MopSubscriptionId --name "mop-fundacion-01" --resource-group $MopResourceGroup --query "{Estado:properties.provisioningState,Error:properties.error}" --output json
```

## 6. Entrega de red y activación posterior

Tras comprobar que la red existe correctamente, cambiar `provisionNetwork=false` y recompilar los parámetros **antes** de que Operaciones asocie rutas o conectividad manual. Mantenerlo en false en despliegues posteriores; los NSG continúan administrados por Bicep.

Operaciones completa enlaces/resolución DNS, rutas y conectividad corporativa, verifica endpoints aprobados, Defender, recepción de logs y monitoreo Dynatrace. La creación de zone groups no crea enlaces de VNet a zonas DNS.

El equipo de aplicación publica código, configura autenticación, dependencias, modelos aprobados y migración de datos. No copiar colas, leases o estado Durable de producción sin un plan de migración. Comprobar el bloqueo de archivos maliciosos, permisos y pruebas de recuperación antes de completar las verificaciones y activar la Function.

## Referencias

- [DNS de plataforma y reglas NSG](https://learn.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16).
- [Diagnósticos y Event Hub](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings).
- [Cuota de App Service](https://learn.microsoft.com/en-us/troubleshoot/azure/app-service/troubleshoot-non-zone-redundant-quota-requests).
