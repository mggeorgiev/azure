#create a storage accoun
STORAGEACCT=$(az storage account create \
                --resource-group $rg \
                --name engineeringdocs$RANDOM \
                --sku Standard_LRS \
                --query "name" | tr -d '"')

#store the primary key for your storage in a variable
STORAGEKEY=$(az storage account keys list \
                --resource-group $rg \
                --account-name $STORAGEACCT \
                --query "[0].value" | tr -d '"')

FILESHARE=$(az storage share create \
                --account-name $STORAGEACCT \
                --account-key $STORAGEKEY \
                --name $FILESHARENAME)

#assign the Microsoft.Storage endpoint to the subnet
az network vnet subnet update \
    --vnet-name ERP-servers \
    --resource-group $rg \
    --name Databases \
    --service-endpoints Microsoft.Storage

az storage account update \
    --resource-group $rg \
    --name $STORAGEACCT \
    --default-action Deny

az storage account network-rule add \
    --resource-group $rg \
    --account-name $STORAGEACCT \
    --vnet $VNET \
    --subnet $SUBNET

SERVERIP="$(az vm list-ip-addresses \
                    --resource-group $rg \
                    --name $Server \
                    --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" \
                    --output tsv)"

ssh -t azureuser@$SERVERIP \
    "mkdir azureshare; \
    sudo mount -t cifs //$STORAGEACCT.file.core.windows.net/$FILESHARE azureshare \
    -o vers=3.0,username=$STORAGEACCT,password=$STORAGEKEY,dir_mode=0777,file_mode=0777,sec=ntlmssp; findmnt \
    -t cifs; exit; bash"

export AZURE_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string \
                                                --resource-group $rg \
                                                --name $STORAGEACCT \
                                                --output tsv)