param location string = resourceGroup().location

// Retrieve NSG IDs from parameters
param webNsgId string
param dataNsgId string

resource secureLabVnet 'Microsoft.Network/virtualNetworks@2024-10-01' = {
  name: 'secureLabVnet'
  location: location
  tags: {
    department: 'IT'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [ '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'webSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
          networkSecurityGroup: {
            id: webNsgId
          }
        }
      }
      {
        name: 'dataSubnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
          networkSecurityGroup: {
            id: dataNsgId
          }
        }
      }

      // Phase 2: Adding Azure Bastion Subnet
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.3.0/26' // Required for Azure Bastion
      }
      }
    ]
  }
}

 output vnetName string = secureLabVnet.name // Output the name of the VNet for use in other modules
