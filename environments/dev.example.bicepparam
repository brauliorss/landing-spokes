using '../infra/main.bicep'

// Ejemplo no desplegable: sustituir todos los PENDIENTE con datos aprobados por CAF.
param location = 'eastus'
param functionAppName = 'func-smartreview-eus-pr'
param functionPlanName = 'asp-smartreview-api-eus-pr'
param frontendAppName = 'app-smartreview-eus-pr'
param frontendPlanName = 'asp-smartreview-web-eus-pr'
param hostStorageAccountName = 'stsmartreviewhosteuspr'
param businessStorageAccountName = 'stsmartreviewdataeuspr'
param cosmosAccountName = 'cosmos-smartreview-eus-pr'
param openAiAccountName = 'oai-smartreview-eus-pr'
param documentIntelligenceAccountName = 'di-smartreview-eus-pr'
param keyVaultName = 'kv-smartreview-eus-pr'

param vnetName = 'vnet-smartreview-eus-pr'
param vnetAddressPrefixes = ['PENDIENTE-IPAM']
param subnetPrefixes = {
  privateEndpoints: 'PENDIENTE-IPAM'
  functionsIntegration: 'PENDIENTE-IPAM'
  frontendIntegration: 'PENDIENTE-IPAM'
}
param provisionNetwork = true
param privateDnsZoneResourceIds = {
  blob: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net'
  queue: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net'
  table: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.table.core.windows.net'
  sites: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net'
  cosmosSql: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com'
  openAi: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com'
  cognitiveServicesAccount: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com'
  keyVault: '/subscriptions/8bfde717-74c9-41c1-853f-cd61b1d8b979/resourceGroups/rg-privatedns-pr/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net'
}

param functionAuthenticationClientId = 'PENDIENTE-REGISTRO-ENTRA-API'
param frontendAuthenticationClientId = 'PENDIENTE-REGISTRO-ENTRA-WEB'
param functionApplicationSettings = {}
param frontendApplicationSettings = {}
param allowedOrigins = []
param activateFunctionApp = false
param activateFrontendApp = false

param tags = { iniciativa: 'SMARTREVIEW', administradoPor: 'Bicep', OpsDept: 'DTI', UserDept: 'PENDIENTE-AREA-FUNCIONAL' }
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
param dynatraceVerified = false
param applicationVerified = false
param securityApprovalId = ''
param processesUntrustedFiles = true
param fileScanningVerified = false
param siemAuthorizationRuleId = 'PENDIENTE-ID-REGLA-EVENT-HUB-SIEM'
param siemEventHubName = 'PENDIENTE-NOMBRE-EVENT-HUB-SIEM'

param models = []
param modelsApproved = false
param batchEnabled = false
param secretNames = []
param hostUsesDurableStorage = true
