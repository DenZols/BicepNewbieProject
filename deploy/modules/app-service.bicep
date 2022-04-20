param containerRegistryName string
param location string
@allowed([
  'dev'
  'prod'
])
param environmentType string = 'dev'
param appServiceAppName string
param prefixName string = 'newbie'

var appServicePlanName = '${prefixName}${uniqueString(resourceGroup().id)}cr'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3' : 'B1'
var appServicePlanTierName = (environmentType == 'prod') ? 'PremiumV3' : 'Basic'

resource appServicePlan 'Microsoft.Web/serverFarms@2020-06-01' = {
  name: appServicePlanName
  kind: 'linux'
  location: location
  sku: {
    name: appServicePlanSkuName
    tier: appServicePlanTierName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2020-06-01' = {
  name: appServiceAppName
  location: location
  kind: 'linux'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: containerRegistryName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    adminUserEnabled: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}
