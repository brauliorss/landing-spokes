using '../infra/main.bicep'

// Ejemplo no desplegable: sustituir todos los PENDIENTE con datos aprobados por CAF.
param location = 'eastus'
param functionAppName = 'func-smartreview-PENDIENTE'
param functionPlanName = 'asp-smartreview-api-PENDIENTE'
param frontendAppName = 'app-smartreview-PENDIENTE'
param frontendPlanName = 'asp-smartreview-web-PENDIENTE'
param applicationInsightsName = 'appi-smartreview-PENDIENTE'
param hostStorageAccountName = 'PENDIENTE'
param businessStorageAccountName = 'PENDIENTE'
param cosmosAccountName = 'cosmos-smartreview-PENDIENTE'
param openAiAccountName = 'oai-smartreview-PENDIENTE'
param documentIntelligenceAccountName = 'di-smartreview-PENDIENTE'
param keyVaultName = 'kv-smartreview-PENDIENTE'

param vnetName = 'vnet-smartreview-PENDIENTE'
param vnetAddressPrefixes = ['PENDIENTE-IPAM']
param subnetPrefixes = {
  privateEndpoints: 'PENDIENTE-IPAM'
  functionsIntegration: 'PENDIENTE-IPAM'
  frontendIntegration: 'PENDIENTE-IPAM'
}
param routeTableResourceId = 'PENDIENTE-ID-TABLA-CAF'
param logAnalyticsWorkspaceResourceId = 'PENDIENTE-ID-LOG-ANALYTICS'
param privateDnsZoneResourceIds = {
  blob: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net'
  queue: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net'
  table: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.table.core.windows.net'
  sites: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net'
  cosmosSql: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com'
  openAi: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com'
  // El ID recibido usa Microsoft.Network/dnszones. Confirmar una zona privateDnsZones antes de desplegar.
  cognitiveServicesAccount: 'PENDIENTE-ID-ZONA-PRIVADA-COGNITIVE-SERVICES'
  keyVault: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net'
}

param functionAuthenticationClientId = 'PENDIENTE-REGISTRO-ENTRA-API'
param frontendAuthenticationClientId = 'PENDIENTE-REGISTRO-ENTRA-WEB'
param functionApplicationSettings = {}
param frontendApplicationSettings = {}
param allowedOrigins = []
param activateFunctionApp = false
param activateFrontendApp = false

param tags = { iniciativa: 'SMARTREVIEW', administradoPor: 'Bicep', DataClassification: 'PENDIENTE-CLASIFICACION', OpsDept: 'DTI', UserDept: 'PENDIENTE-AREA-FUNCIONAL' }
param apiClientPrefixes = []
param operatorPrefixes = []
param monitorPrefixes = []
param functionPrivateIps = []
param frontendPrivateIps = []
param cosmosPrivateIps = []
param allowedPrincipalIds = []
param extraEgress = []
param inventoryVerified = false
param networkVerified = false
param defenderVerified = false
param siemVerified = false
param monitoringPrivateLinkVerified = false
param applicationVerified = false
param securityApprovalId = ''
param processesUntrustedFiles = true
param fileScanningVerified = false
param actionGroupResourceId = ''
param siemAuthorizationRuleId = 'PENDIENTE-ID-REGLA-EVENT-HUB-SIEM'
param siemEventHubName = 'PENDIENTE-NOMBRE-EVENT-HUB-SIEM'

param models = []
param modelsApproved = false
param batchEnabled = false
param secretNames = []
param hostUsesDurableStorage = true
