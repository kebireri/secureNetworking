#Create a new resource group

az group create \
  --name <RESOURCE_GROUP_NAME> \
  --location <AZURE_REGION>

--------------------


#Deploy the Template
#Actually build your secure VNet, subnets, and NSGs.

az deployment group create \
  --resource-group <RESOURCE_GROUP_NAME> \
  --template-file <PATH_TO_BICEP_FILE>


--------------------


#Check Deployment Status

az deployment group show \
  --resource-group <RESOURCE_GROUP_NAME> \
  --name <DEPLOYMENT_NAME>

--------------------

#Check Subnet–NSG Associations

# For the web subnet
az network vnet subnet show \
  --resource-group <RESOURCE_GROUP_NAME> \
  --vnet-name <VNET_NAME> \
  --name <SUBNET_NAME> \
  --query networkSecurityGroup

# For the data subnet
az network vnet subnet show \
  --resource-group <RESOURCE_GROUP_NAME> \
  --vnet-name secureLabVNet \
  --name dataSubnet \
  --query "networkSecurityGroup.id"

--------------------

#End of Script
