#cleanup script to destroy all resources created by the deployment script

#Delete the Resource Group and all associated resources

az group delete \
  --name <RESOURCE_GROUP_NAME> \
  --yes \
  --no-wait

#End of Script

 