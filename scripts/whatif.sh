#Preview Deployment (What-If)
#Useful for previewing changes before deployment.

az deployment group what-if \
  --resource-group <RESOURCE_GROUP_NAME> \
  --template-file <PATH_TO_BICEP_FILE>

#End of Script

 
