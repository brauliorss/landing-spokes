# Preparación del despliegue de Smart Review

Revisión del 19 de octubre de 2026. Se conservaron siete IDs de zonas DNS privadas suministrados y se propusieron nombres de recursos con la convención `eus-pr`. La zona privada de Document Intelligence queda pendiente de confirmación. La configuración todavía no está lista para desplegar. Completar la copia local `environments/prod.bicepparam`, excluida de Git.

## DNS central

Las zonas corresponden a Blob, Queue, Table, App Service, Cosmos DB, OpenAI, Document Intelligence y Key Vault, en `rg-privatedns-pr` de la suscripción `8bfde717-74c9-41c1-853f-cd61b1d8b979`.

El ID recibido para `privatelink.cognitiveservices.azure.com` contiene `Microsoft.Network/dnszones`, no `Microsoft.Network/privateDnsZones`. Se dejó un marcador pendiente en ambos archivos de parámetros. Plataforma debe entregar el ID de la zona privada; cambiar la ruta en el archivo no crea ni convierte la zona.

Esta revisión es local y no comprueba la existencia de las zonas en Azure. Plataforma debe confirmar también permisos sobre las zonas centrales, enlaces y resolución desde el spoke.

## Datos pendientes para crear la infraestructura

| Dato o decisión | Responsable | Pendiente |
| --- | --- | --- |
| Destino y nombres | Plataforma | Confirmar suscripción y RG nuevo de destino. Los nombres de Smart Review utilizan `eus-pr`; los dos Storage utilizan el mismo sufijo sin guiones. Confirmar disponibilidad global antes de desplegar. |
| Direccionamiento | Redes / IPAM | Entregar una VNet /24 y los rangos de las tres subredes. |
| Rutas | Redes | Entregar el ID de la tabla de rutas corporativa existente y confirmar compatibilidad con la nueva red. |
| Monitoreo | Plataforma | Entregar el ID del Log Analytics central. |
| SIEM | Seguridad / Plataforma | Entregar el ID de la regla de autorización del namespace Event Hub y el nombre del Event Hub. |
| Identidad | Identidad | Entregar los dos identificadores de aplicación Entra, para API y frontend. |
| Clasificación | Dueño de la solución | Completar clasificación de datos y área funcional. |
| Validación en Azure | Plataforma | Confirmar permisos, disponibilidad de nombres, capacidad regional y ejecutar validación y vista previa de cambios con los parámetros definitivos. |

## Condiciones para poner el servicio en funcionamiento

La base permite crear las aplicaciones detenidas y sin modelos. Para activarlas se requieren conexión al hub, rutas de retorno, DNS privado y AMPLS; direcciones privadas y rangos autorizados; identidades autorizadas; Action Group para el backend; verificaciones de Defender, SIEM, análisis de archivos y aprobación de seguridad.

El equipo de aplicación debe publicar frontend y backend, preparar configuración y secretos, migrar los datos y la autenticación a Entra, confirmar el runtime y Durable, configurar las dependencias compartidas y definir los modelos con versión, capacidad y cuota aprobadas. Finalmente debe completar las pruebas de acceso privado, autenticación, procesamiento de documentos y monitoreo.

No se realizó despliegue ni modificación de recursos Azure durante esta actualización.
