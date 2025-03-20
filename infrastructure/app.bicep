targetScope = 'resourceGroup'

param location string = 'swedencentral'
param appName string = 'app-elprice'
param sku string = 'F1'
param osType string = 'linux'
param runtimeStack string = 'PYTHON:3.9'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'asp-${appName}'
  location: location
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
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: runtimeStack
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~18'
        }
        {
          name: 'PYTHON_ENABLE_WORKER_EXTENSIONS'
          value: '1'
        }
        {
          name: 'SCM_USE_LIBGIT2SHARED'
          value: '1'
        }
        {
          name: 'WEBSITE_WEBDEPLOY_USE_SCM'
          value: 'true'
        }
        {
          name: 'WEBSITE_HTTPLOGGING_RETENTION_DAYS'
          value: '7'
        }
        {
          name: 'WEBSITE_ENABLE_SYNC_UPDATE_SITE'
          value: 'true'
        }
      ]
    }
  }
}

output webAppName string = webApp.name
output webAppId string = webApp.id 
