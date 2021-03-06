#!/bin/bash


### Variables
resourceGroup="sqldb-rsg"
location=westeurope
vnetName="sqldb-vnet"
subnetName="subnet001"
addressPrefixes="10.0.0.0/16"
subnetPrefixes="10.0.0.0/24"
adminPassword=StrongPassword
adminUser=adminuser
sqlserver=sqlserver
dbname=dbname

az account set -s subscription

# Create resource group
if [ $(az group exists --name ${resourceGroup}) = false ]; then
    echo "Create resource group: ${resourceGroup}"
    az group create --name $resourceGroup \
                    --location $location
fi

### Temporary mockup for the Fujitsu subscription
az network vnet create \
    --resource-group ${resourceGroup}\
    --location westeurope \
    --name $vnetName \
    --address-prefixes $addressPrefixes \
    --subnet-name $subnetName \
    --subnet-prefixes $subnetPrefixes

az network vnet subnet update --name snt-digitwkpl-weu1-p-001-lan --resource-group ${resourceGroup} --vnet-name $vnetName --disable-private-endpoint-network-policies true

az sql server create --admin-password $adminPassword \
                     --admin-user $adminUser \
                     --name $sqlserver \
                     --resource-group $resourceGroup \
                     --enable-public-network true \
                     --location $location

az sql db create --resource-group $resourceGroup \
                 -s $sqlserver \
                 -n $dbname \
                 --service-objective S0 \
                 --zone-redundant false

id=$(az sql server list \
    --resource-group ${resourceGroup} \
    --query '[].[id]' \
    --output tsv)

az network private-endpoint create \
    --name myPrivateEndpoint \
    --resource-group ${resourceGroup} \
    --vnet-name $vnetName --subnet $subnetName \
    --private-connection-resource-id $id \
    --group-ids sqlServer \
    --connection-name sqlConnection

az sql db list --server $sqlserver --resource-group $resourceGroup --output tsv

az sql db show --server $sqlserver --resource-group $resourceGroup --name $databaseName

az sql server conn-policy show --server $sqlserver --resource-group $resourceGroup

# update connectivity policy 
az sql server conn-policy update --server $sqlserver --resource-group $resourceGroup --connection-type Proxy ##Redirect / Default
# confirm update
az sql server conn-policy show --server $sqlserver --resource-group $resourceGroup

#Condifure defaults
#az configure --defaults group=$resourceGroup sql-server=$logical_server

#Use az configure --list-defaults to find the location of the file and clean it 
#az configure --list-defaults