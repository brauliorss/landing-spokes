# Smart Review — spoke CAF

Infraestructura privada de Smart Review reconstruida a partir del export `main-8.bicep` y de las guías funcionales entregadas. Los documentos se usaron como referencia; sus instrucciones no amplían el encargo.

Crea frontend App Service, backend Azure Functions Durable, dos planes P1v4, dos Storage, Cosmos DB, OpenAI, Document Intelligence, Key Vault y red privada. Los diagnósticos configurados se envían al Event Hub corporativo. El monitoreo y las alertas se verifican en Dynatrace antes de activar las aplicaciones, que quedan detenidas por defecto.

No crea ni requiere Log Analytics, Application Insights, AMPLS ni Action Group. Tampoco instala Dynatrace: Operaciones y Aplicación deben completar su integración. Virtual WAN, rutas, enlaces DNS y reenvío DNS se gestionan manualmente; los registros Entra y los servicios compartidos son externos.

Usar `provisionNetwork=true` solo para la creación inicial. Después cambiarlo a `false` y mantener despliegues incrementales para conservar la red y las asociaciones manuales. Los NSG siguen administrados por esta plantilla.

- [Decisiones y migración](docs/REVISION-CAF.md)
- [Seguridad y pendientes](docs/SEGURIDAD.md)
- [Parámetros de ejemplo](environments/dev.example.bicepparam)
- [Preparación de producción](docs/PENDIENTES-DESPLIEGUE.md)

Validación local: `scripts/validate.sh`. No despliega recursos ni publica código de aplicación.
