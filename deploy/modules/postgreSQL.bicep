param postgreSqlName string
param location string
param postgresSkuName object = {
  name: 'Standard_B1ms'
  tier: 'Burstable'
}
@secure()
param postgreSQLAdministratorLogin string
@secure()
param postgreSsqlAdministraotrPassword string

resource DBserver 'Microsoft.DBforPostgreSQL/flexibleServers@2021-06-01' = {
  name: postgreSqlName
  location: location
  sku: {
    name: postgresSkuName.name
    tier: postgresSkuName.tier
  }
  properties: {
    administratorLogin: postgreSQLAdministratorLogin
    administratorLoginPassword: postgreSsqlAdministraotrPassword
    storage: {
      storageSizeGB: 32
    }

    createMode: 'Default'
    version: '13'
  }
}
resource postgreSQLDatabasee 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2021-06-01' = {
  name: '$BicepDataBase'
  parent: DBserver
}
