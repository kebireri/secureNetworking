//Part 2

@description('Azure region for deployment')
param location string

@description('Name of the Virtual Network')
param vnetName string

@description('subnet name for Azure Bastion')
param bastionSubnetName string = 'AzureBastionSubnet' // Azure Bastion requires this exact subnet name

@description('public IP for Azure Bastion (Standard, static)')
resource bastionPublicIP 'Microsoft.Network/publicIPAddresses@2024-10-01' = {
  name: 'bastionPublicIP'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 15
  }
  tags: {
    department: 'IT' // Tag to comply with the policy in the earlier project IAC project
}
}

@description('Azure Bastion Host')
resource azureBastionHost 'Microsoft.Network/bastionHosts@2024-10-01' = {
  name: 'azureBastionHost'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'bastionIpConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, bastionSubnetName)
          }
          publicIPAddress: {
            id: bastionPublicIP.id
          }
        }
      }
    ]
  }
  tags: {
    department: 'IT' // Tag to comply with the policy in the earlier project IAC project https://github.com/kebireri/azure-bicep/tree/main/infrastructureAsCode
  }
}
