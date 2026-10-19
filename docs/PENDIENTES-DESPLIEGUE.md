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

## Datos pendientes para crear la infraestructura

| Dato o decisión | Responsable | Pendiente |
| --- | --- | --- |
| Destino y nombres | Plataforma | Destino confirmado: suscripción `ae7edd5e-9919-4ddf-95b7-93b4a5061949`, grupo `RG-SMARTREVIEW-PR`. Confirmar disponibilidad global de los nombres antes de desplegar. |
| Rutas | Redes | Entregar el ID de la tabla de rutas corporativa existente y confirmar compatibilidad con la nueva red. |
| Monitoreo | Plataforma / Aplicación | Operaciones indicó Dynatrace para monitoreo y Event Hub para logs. Adaptar la plantilla, que todavía exige Log Analytics y Application Insights, y acordar la integración con Dynatrace. No crear Log Analytics con la configuración actual. |
| Envío de logs | Seguridad / Plataforma | Event Hub identificado: `evh-taegis-pr`, namespace `caf-eventhub-pr-01`. Falta el ID de la regla de autorización del namespace. Confirmar región East US, permisos y acceso para Azure Monitor. No compartir claves ni cadenas de conexión. |
| Identidad | Identidad / Aplicación | Los dos identificadores de aplicación ya están guardados en la configuración local. Completar la configuración de autenticación y autorización de las aplicaciones. |
| Clasificación | Dueño de la solución | Completar clasificación de datos y área funcional. |
| Validación en Azure | Plataforma | Confirmar permisos, disponibilidad de nombres, capacidad regional y ejecutar validación y vista previa de cambios con los parámetros definitivos. |

## Condiciones para poner el servicio en funcionamiento

La base contempla crear las aplicaciones detenidas y sin modelos. Antes de desplegar debe resolverse la adaptación a Dynatrace y Event Hub. La versión actual todavía exige AMPLS y Action Group para la activación; esos requisitos deben revisarse junto con el cambio de monitoreo, no darse por cumplidos. Para activar el servicio se requieren conectividad corporativa, rutas de retorno, DNS privado, direcciones privadas y rangos autorizados, identidades autorizadas, verificaciones de Defender y recepción de logs, análisis de archivos y aprobación de seguridad.

El equipo de aplicación debe publicar frontend y backend, preparar configuración y secretos, migrar los datos y la autenticación a Entra, confirmar el runtime y Durable, configurar las dependencias compartidas y definir los modelos con versión, capacidad y cuota aprobadas. Finalmente debe completar las pruebas de acceso privado, autenticación, procesamiento de documentos y monitoreo.

No se realizó despliegue ni modificación de recursos Azure durante esta actualización.
