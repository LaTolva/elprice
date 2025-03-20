targetScope = 'subscription'

param location string = 'swedencentral'
param appName string = 'app-elprice'
param sku string = 'F1'
param osType string = 'linux'
param runtimeStack string = 'PYTHON:3.9'
param resourceGroupName string = 'rg-elprice-lasse'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
  properties: {
    tags: {
      Environment: 'Development'
      Project: 'ElectricityPriceAPI'
    }
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'asp-${appName}'
  location: location
  resourceGroup: resourceGroupName
  sku: {
    name: sku
    tier: sku == 'F1' ? 'Free' : 'Basic'
  }
  kind: osType
  properties: {
    reserved: true
    maximumElasticWorkerCount: 1
    perSiteScaling: false
    targetWorkerCount: 1
  }
}

resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: appName
  location: location
  resourceGroup: resourceGroupName
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: runtimeStack
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
    }
  }
}

output webAppName string = webApp.name
output webAppId string = webApp.id 
