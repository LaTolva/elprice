targetScope = 'subscription'

param location string = 'swedencentral'
param resourceGroupName string = 'rg-elprice-lasse'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
  tags: {
    Environment: 'Development'
    Project: 'ElectricityPriceAPI'
  }
}

output resourceGroupId string = resourceGroup.id 
