param location string = resourceGroup().location

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
            // Updated in manin.bicep
          }
        }
      }
      {
        name: 'dataSubnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
          networkSecurityGroup: {
            // Updated in main.bicep
          }
        }
      }
    ]
  }
}

