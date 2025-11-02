@description('Location for all resources')
param location string = resourceGroup().location

@description('Existing Hub Virtual Network') // Reference to existing hub vnet
param hubVnetName string = 'secureLabVnet'


// Point to existing vnet created in earlier modules (secureLabVnert)
resource hubVnet 'Microsoft.Network/virtualNetworks@2024-10-01' existing = {
  name: hubVnetName
}



// Create Spoke Virtual Network and a Subnet

resource spokeVnet 'Microsoft.Network/virtualNetworks@2024-10-01' = {
  name: 'spokeVnet'
  location: location
  tags: {
    department: 'IT' // Tag to comply with the policy in the earlier project IAC project
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ] // Spoke VNet address space
    }
    subnets: [
      {
        name: 'Appsubnet'
        properties: {
          addressPrefix: '10.1.1.0/24'
        } // Application subnet
      }
    ]
  }
}

// VNet Peering from Hub to Spoke
resource hubToSpokePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-10-01' = {
  name: 'hubToSpokePeering'
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: {
      id: spokeVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

// VNet Peering from Spoke to Hub
resource spokeToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-10-01' = {
  name: 'spokeToHubPeering'
  parent: spokeVnet
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
} 
