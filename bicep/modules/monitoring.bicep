@description('Azure location for all resources.')
param location string = resourceGroup().location

param lawName string = 'secureLab-law'
param department string = 'IT'
param retentionInDays int = 30



resource law 'Microsoft.OperationalInsights/workspaces@2025-02-01' = {
  name: lawName
  location: location
  tags: {
    department: department
  }
  properties: {
    retentionInDays: retentionInDays
    sku: {
      name: 'PerGB2018'
    }
    features: {
      legacy: 0 // Disable legacy features
    }
  }
}

output lawId string = law.id
output lawNameOutput string = law.name
output lawworkspaceId string = law.properties.customerId
