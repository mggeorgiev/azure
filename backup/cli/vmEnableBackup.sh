#!/bash/bin

#Script was created by ...
recoveryServicesVaultName="plazRSV"
resourceGroupName="plazRG"
virtualMachineName="plazVM"
location="eastus"
adminName="plazadmin"
retainUntil=$(date -d "+14 days" +'%d-%m-%Y')

vmId=$(az vm show --resource-group ${resourceGroupName} --name ${virtualMachineName} -d --query [id] --output tsv)

#Check if the vm is already protected
if [ -z $(az backup protection check-vm --vm-id $vmId) ]
then
      echo "\${virtualMachineName} is not protected"
        # enable backup
        az backup protection enable-for-vm --resource-group $resourceGroupName --vault-name $recoveryServicesVaultName --vm $virtualMachineN$
else
      echo "\${virtualMachineName} is protected"
fi

# initial backup
az backup protection backup-now \
            --resource-group $resourceGroupName \
            --vault-name $recoveryServicesVaultName \
            --container-name $virtualMachineName \
            --item-name $virtualMachineName \
            --backup-management-type AzureIaasVM \
            --retain-until $retainUntil

# watch backup
az backup job list --resource-group $resourceGroupName --vault-name $recoveryServicesVaultName --output table
