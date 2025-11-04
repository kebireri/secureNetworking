@description('Location for all resources')
param location string = resourceGroup().location

@description('Name of the existing Hub Virtual Network (secureLabVnet)')
param secureLabVnetName string = 'secureLabVnet'

// Add NSG to subnet in spoke


// Admin username and SSH key for VM access
@secure()
param adminUsername string

@secure()
param sshKey string



// Point to existing vnet created in earlier modules (secureLabVnert)
resource hubVnet 'Microsoft.Network/virtualNetworks@2024-10-01' existing = {
  name: secureLabVnetName
}


// NSG for Phase 4 implementation (ap subnet and bastion), created after phase 3 implementation

resource appSubnetNsg 'Microsoft.Network/networkSecurityGroups@2024-10-01' = {
   name: 'appSubnetNsg'
   location: location
   tags: {
     department: 'IT'
   }
   properties: {
     securityRules: [
       {
         name: 'Allow-Bastion-SSH'
         properties: {
          priority: 500
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '10.20.1.0/24'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'      //linux ssh
         }
       }
     ]
   }
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
        name: 'appSubnet'
        properties: {
          addressPrefix: '10.1.1.0/24'
          networkSecurityGroup: {
            id: appSubnetNsg.id
          }
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

resource appNic 'Microsoft.Network/networkInterfaces@2024-10-01' = {
  name: 'appNic'
  location: location
  tags: {
    department: 'IT'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'appIpConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'spokeVnet', 'appSubnet')
          }
          privateIPAllocationMethod: 'Dynamic'
          
        }
      }
    ]
  }
}

// Virtual Machine in the Spoke VNet App Subnet
resource appVm 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: 'appVm'
  location: location
  tags: {
    department: 'IT'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    osProfile: {
      computerName: 'appVm'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: sshKey
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: appNic.id
        }
      ]
    }
  } 
}
              
