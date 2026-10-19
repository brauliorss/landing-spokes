# Seguridad de Smart Review

## Controles incorporados

- Acceso público deshabilitado y endpoints privados para frontend, Function, Storage, Cosmos, OpenAI, Document Intelligence y Key Vault.
- Tres subredes separadas y NSG con denegación por defecto. Las rutas y conexiones corporativas se gestionan manualmente y deben verificarse antes de activar.
- Entra obligatorio en las dos aplicaciones; identidades administradas y RBAC de datos acotado para el backend.
- Storage sin Shared Key, blobs sin acceso público, retención de borrado de 14 días y Defender heredado de la suscripción.
- Cosmos sin autenticación local, respaldo continuo y permiso limitado a `contracts-dco-db`.
- Diagnósticos hacia Event Hub corporativo. El par `siemAuthorizationRuleId`/`siemEventHubName` es obligatorio y referencia la política del namespace, no la de un Event Hub individual.
- Monitoreo y alertas en Dynatrace; ambas aplicaciones requieren `dynatraceVerified=true` para activarse. No se exige Log Analytics, Application Insights, AMPLS ni Action Group.
- Las aplicaciones permanecen detenidas hasta registrar verificaciones de inventario, red, aplicación, seguridad y monitoreo.

## Responsabilidades pendientes

Plataforma debe completar manualmente la conexión corporativa, rutas de retorno y DNS forwarding; confirmar zonas, resolución privada y permisos de envío al Event Hub. Operaciones y Aplicación completan Dynatrace, alertas y notificaciones con evidencia de recepción. Identidad configura los registros Entra entregados. Seguridad confirma Defender, análisis de archivos, cobertura de modelos y recepción en el destino corporativo de logs.

Después de crear la red, fijar `provisionNetwork=false` antes de modificarla manualmente. Los despliegues posteriores deben ser incrementales y no reescribir VNet/subredes. Las reglas NSG permanecen bajo control de Bicep. No reabrir salidas públicas para resolver dependencias de monitoreo; acordar los destinos y puertos requeridos.

El equipo de aplicación debe migrar Function keys a Entra, publicar frontend/backend, confirmar Python y Durable, configurar dependencias compartidas y manejar documentos pendientes, maliciosos o no analizados con cierre seguro. El Bicep no prueba esas condiciones.

## Aceptación

Registrar evidencia de: DNS y SCM privados; rechazo público; 401 sin token; autorización positiva/negativa; acceso a cada contenedor y Cosmos; Durable; OCR/OpenAI/Batch; bloqueo de archivos; recepción de logs corporativos y telemetría en Dynatrace; alertas y notificaciones; restauración y rollback. Compilar la plantilla no equivale a validar ni desplegar en Azure.
