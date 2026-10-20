targetScope = 'resourceGroup'

param location string
param tags object = {}
param vnetName string
param vnetAddressPrefixes array
param subnetPrefixes object
param provisionNetwork bool
param apiClientPrefixes array
param operatorPrefixes array
param monitorPrefixes array
param cosmosPrivateIps array
param functionPrivateIps array
param extraEgress array

var subnetDefinitions = [
  {
    name: 'snet-private-endpoints'
    prefix: subnetPrefixes.privateEndpoints
    delegation: ''
    privateEndpointNetworkPolicies: 'Enabled'
  }
  {
    name: 'snet-functions-integration'
    prefix: subnetPrefixes.functionsIntegration
    delegation: 'Microsoft.Web/serverFarms'
    privateEndpointNetworkPolicies: 'Disabled'
  }
]

module subnetNsgs './nsg.bicep' = [for (purpose, i) in ['privateEndpoints', 'functionsIntegration']: {
  name: 'nsg-${purpose}'
  params: {
    name: 'nsg-${subnetDefinitions[i].name}'
    location: location
    tags: tags
    purpose: purpose
    prefixes: subnetPrefixes
    apiClientPrefixes: apiClientPrefixes
    operatorPrefixes: operatorPrefixes
    monitorPrefixes: monitorPrefixes
    functionPrivateIps: functionPrivateIps
    cosmosPrivateIps: cosmosPrivateIps
    extraEgress: extraEgress
  }
}]

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = if (provisionNetwork) {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefixes
    }
    subnets: [for (subnet, index) in subnetDefinitions: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.prefix
        networkSecurityGroup: {
          id: subnetNsgs[index].outputs.id
        }
        privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
        delegations: empty(subnet.delegation) ? [] : [
          {
            name: 'delegation'
            properties: {
              serviceName: subnet.delegation
            }
          }
        ]
      }
    }]
  }
}

var networkId = resourceId('Microsoft.Network/virtualNetworks', vnetName)
output vnetId string = networkId
output vnetName string = vnetName
output peSubnetId string = '${networkId}/subnets/snet-private-endpoints'
output functionsIntegrationSubnetId string = '${networkId}/subnets/snet-functions-integration'
