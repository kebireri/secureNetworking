param location string = resourceGroup().location

// Network Security Group for web subnet to allow HTTP, HTTPS, and SSH traffic

resource webSubnetNsg 'Microsoft.Network/networkSecurityGroups@2024-10-01' = { 
  name: 'webSubnetNsg'
  location: location
  tags: {
    department: 'IT'
  }
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTPS'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443' // Allow HTTPS traffic
        }
      }
      {
        name: 'Allow-HTTP'
        properties: {
          priority: 200
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80' // Allow HTTP traffic
        }
      }
      {
        name: 'allow-SSH'
        properties: {
          priority: 300
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '' // Allow from your IP or trusted sources <enter your IP here>
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
      {
        name: 'Deny-All-Others'
        properties: {
          priority: 400
          protocol: '*'
          access: 'Deny'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

// Network Security Group for the data subnet to allow traffic on port 1433 from webSubnetonly
resource dataSubnetNsg 'Microsoft.Network/networkSecurityGroups@2024-10-01' = { 
  name: 'dataSubnetNsg'
  location: location
  tags: {
    department: 'IT'
  }
  properties: {
    securityRules: [
      {
        name: 'Allow-SQL-From-WebSubnet'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '10.0.1.0/24' // Allow only from webSubnet
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '1433'
        }
      }
      {
        name: 'Deny-All-Others'
        properties: {
          priority: 400
          protocol: '*'
          access: 'Deny'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}
