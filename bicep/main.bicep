param location string = resourceGroup().location



// Network Security Groups
module nsg 'modules/nsg.bicep' = {
  name: 'nsgModule'
  params: {
    location: location
  }
}

// Virtual Network with subnets

module vnet 'modules/vnet.bicep' = {
  name: 'vnetModule'
  params: {
    location: location
    webNsgId: nsg.outputs.webNsgId
    dataNsgId: nsg.outputs.dataNsgId
  }
}

// Azure Bastion Module Deployment

module bastion 'modules/bastion.bicep' = {
  name: 'bastion'
  params: {
    location: location
    vnetName: vnet.outputs.vnetName
  }
}

