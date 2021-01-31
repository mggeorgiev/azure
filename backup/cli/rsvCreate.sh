#!/bash/bin

#Script was created by ...
recoveryServicesVaultName="plazRSV"
resourceGroupName="rsg-xxxx-core-p-001"
location="westeurope"

#create recovery vault
az backup vault create --resource-group $resourceGroupName --name $recoveryServicesVaultName --location $location

#create backup policy