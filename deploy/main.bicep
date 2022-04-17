param prefixName string = 'newbie'

param appServiceName string = '${prefixName}-${uniqueString(resourceGroup().id)}-app'
param postgrSQLDbName string = '${prefixName}-${uniqueString(resourceGroup().id)}-psql'
param keyVaultName string = '${prefixName}-${uniqueString(resourceGroup().id)}-kv'
param containerRegistryName string = '${prefixName}${uniqueString(resourceGroup().id)}cr'

param location string = resourceGroup().location
@allowed([
  'dev'
  'prod'
])
param environmentType string
@secure()
param sqlServerAdministratorLogin string
@secure()
param sqlServerAdministratorPassword string
module appService './modules/app-service.bicep' = {
  name: appServiceName
  params: {
    location: location
    environmentType: environmentType
    appServiceAppName: appServiceName
    containerRegistryName: containerRegistryName
  }
}
module postgreSQLDB 'modules/postgreSQL.bicep' = {
  name: postgrSQLDbName
  params: {
    location: location
    postgreSQLAdministratorLogin: sqlServerAdministratorLogin
    postgreSqlName: postgrSQLDbName
    postgreSsqlAdministraotrPassword: sqlServerAdministratorPassword
  }
}
resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' ={
  name: keyVaultName
  location: location
  properties:{
    createMode: 'default'
    enabledForDeployment: true
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    enableSoftDelete: false
    enableRbacAuthorization: true
    enablePurgeProtection: true
    networkAcls:{
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    sku:{
      family: 'A'
      name: 'standard'
    }
    tenantId:tenant().tenantId
  }
}


