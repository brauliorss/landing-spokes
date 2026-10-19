# Preparación del despliegue de Smart Review

Revisión del 19 de octubre de 2026. Se recibieron los ocho IDs de zonas DNS privadas y el rango de red de Smart Review. Los nombres utilizan la convención `eus-pr`. La configuración todavía no está lista para desplegar. Los datos de producción se guardan en `environments/prod.bicepparam`, excluido de Git.

## DNS central

Las zonas corresponden a Blob, Queue, Table, App Service, Cosmos DB, OpenAI, Document Intelligence y Key Vault, en `rg-privatedns-pr` de la suscripción `8bfde717-74c9-41c1-853f-cd61b1d8b979`.

Se incorporó el nuevo ID suministrado para `privatelink.cognitiveservices.azure.com`, de tipo `Microsoft.Network/privateDnsZones`. Sustituye la referencia anterior a la zona pública; esta actualización no modifica ni elimina esa zona pública.

Esta revisión es local y no comprueba la existencia de las zonas en Azure. Plataforma debe confirmar también permisos sobre las zonas centrales, enlaces y resolución desde el spoke.

## Red de producción

El despliegue creará `vnet-smartreview-eus-pr` con el rango entregado `10.161.109.0/24`. No crear previamente la misma red de forma manual sin ajustar el despliegue.

| Subred | Rango | Uso |
| --- | --- | --- |
| `snet-private-endpoints` | `10.161.109.0/27` | Puntos de conexión privados |
| `snet-functions-integration` | `10.161.109.64/26` | Integración del backend |
| `snet-frontend-integration` | `10.161.109.128/26` | Integración del frontend |

Quedan sin asignar `10.161.109.32/27` y `10.161.109.192/26`. Las subredes de integración se delegan a `Microsoft.Web/serverFarms`. Redes debe verificar que el rango entregado está reservado para Smart Review y completar la conectividad corporativa y la resolución DNS.

### Creación inicial y gestión posterior

1. Para la primera creación, mantener `provisionNetwork=true` y las dos aplicaciones detenidas. Comprobar antes que no existe una red con ese nombre que deba conservarse.
2. Al terminar la creación, cambiar `provisionNetwork=false` en los parámetros locales y volver a generar el archivo de parámetros de despliegue. Hacerlo antes de que Operaciones complete las asociaciones manuales, incluso si todavía faltan pruebas de red.
3. Operaciones configura la conexión corporativa, las rutas que correspondan y la resolución DNS. No se exige un ID de tabla de rutas en los parámetros.
4. En las siguientes actualizaciones, mantener `provisionNetwork=false` y modo `Incremental`. La plantilla no vuelve a escribir la VNet ni sus subredes, pero sigue actualizando sus NSG. Las reglas de esos NSG deben mantenerse en la configuración, no añadirse manualmente.
5. No volver a usar `true` sobre la red entregada a Operaciones: podría restablecer asociaciones y otras propiedades. Para cambiar direccionamiento o subredes, coordinar una modificación de red separada. No usar modo `Complete`.

Si la red ya fue creada fuera de esta plantilla, no continuar con `true`: confirmar nombres de subredes, rangos, delegaciones y asociaciones a los NSG esperados antes de usar `false`.

## Datos pendientes para crear la infraestructura

| Dato o decisión | Responsable | Pendiente |
| --- | --- | --- |
| Destino y nombres | Plataforma | Destino confirmado: suscripción `ae7edd5e-9919-4ddf-95b7-93b4a5061949`, grupo `RG-SMARTREVIEW-PR`. Confirmar disponibilidad global de los nombres antes de desplegar. |
| Rutas | Redes | Gestionar manualmente la conectividad y las rutas necesarias después de crear la red. No se requiere ID de tabla en Bicep. |
| Monitoreo | Plataforma / Aplicación | La plantilla ya no exige Log Analytics, Application Insights, AMPLS ni Action Group. Acordar y completar la integración de frontend y backend con Dynatrace, incluyendo alertas y prueba de recepción antes de activar. |
| Envío de logs | Seguridad / Plataforma | Event Hub `evh-taegis-pr`, namespace `caf-eventhub-pr-01`, en `RG-MANAGEMENT-PR` de la suscripción `055e400d-5557-4672-bab7-e18f7658fd4d`. Se recibió y guardó el ID de la política del namespace `RootManageSharedAccessKey`. El usuario confirmó East US y el uso de la política con Operaciones. Falta comprobar permisos del ejecutor, acceso para Azure Monitor y recepción efectiva de logs. No compartir claves ni cadenas de conexión. |
| Identidad | Identidad / Aplicación | Los dos identificadores de aplicación ya están guardados en la configuración local. Completar la configuración de autenticación y autorización de las aplicaciones. |
| Etiquetas | Dueño de la solución | Los únicos marcadores restantes en los parámetros locales son `tags.DataClassification` y `tags.UserDept`. Proporcionar valores aprobados o confirmar un cambio del contrato de etiquetas; no inventar valores ni asumir herencia del RG. |
| Validación en Azure | Plataforma | Confirmar permisos, disponibilidad de nombres, capacidad regional y ejecutar validación y vista previa de cambios con los parámetros definitivos. |

## Condiciones para poner el servicio en funcionamiento

La base permite crear las aplicaciones detenidas y sin modelos una vez completadas las etiquetas y superadas las comprobaciones de Azure. Para activar el servicio se requieren conectividad corporativa, rutas de retorno, DNS privado, direcciones privadas y rangos autorizados, identidades autorizadas, verificaciones de Defender y recepción de logs, análisis de archivos y aprobación de seguridad. Mantener `provisionNetwork=false` para la activación.

`dynatraceVerified` sustituye a `monitoringPrivateLinkVerified` y debe permanecer en `false` hasta disponer de evidencia de monitoreo y alertas para ambas aplicaciones. Enviar logs al Event Hub no instala Dynatrace ni demuestra que la aplicación esté instrumentada. Las variables seguras de aplicación permiten incorporar la configuración aprobada; no se añaden agentes, tokens, destinos ni scripts de inicio sin conocer el método corporativo. Los cambios manuales de configuración de aplicaciones también deben reflejarse en los parámetros antes de redesplegar.

`monitorPrefixes` es opcional y habilita salida TCP 443 desde ambas subredes de integración hacia los destinos privados indicados. Solo completarlo si el método de monitoreo acordado lo requiere; otros puertos o mecanismos requieren revisión explícita. Se eliminó la salida general hacia Azure Monitor desde las aplicaciones. El envío de diagnósticos de plataforma al Event Hub no depende de esa regla.

Para Event Hub, comprobar permisos en las suscripciones de origen y destino, permiso de lectura de claves de la política para el ejecutor, compatibilidad regional y acceso de servicios Microsoft de confianza cuando corresponda. Mantener `siemVerified=false` hasta verificar la recepción efectiva en el destino corporativo. No introducir secretos en los archivos ni en el historial de comandos.

El equipo de aplicación debe publicar frontend y backend, preparar configuración y secretos, migrar los datos y la autenticación a Entra, confirmar el runtime y Durable, configurar las dependencias compartidas y definir los modelos con versión, capacidad y cuota aprobadas. Finalmente debe completar las pruebas de acceso privado, autenticación, procesamiento de documentos y monitoreo.

No se realizó despliegue ni modificación de recursos Azure durante esta actualización.

## Referencias operativas

- [Requisitos de diagnósticos y Event Hub](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings).
- [Actualizaciones incrementales y conservación de propiedades de red](https://learn.microsoft.com/es-es/azure/azure-resource-manager/templates/deployment-modes).
- [Integración de Dynatrace en App Service Linux](https://docs.dynatrace.com/docs/ingest-from/microsoft-azure-services/integrations/azure-appservice/integrate-oneagent-on-web-app-for-containers).
- [Trazas Python de Azure Functions con Dynatrace](https://docs.dynatrace.com/docs/ingest-from/microsoft-azure-services-classic/azure-integrations/azure-functions-classic/func-dynamic-plans/opentelemetry-on-azure-functions-python). Confirmar con Operaciones la compatibilidad del método seleccionado con el runtime y plan de Smart Review.
