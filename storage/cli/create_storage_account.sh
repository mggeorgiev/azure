#!/bin/bash

read -p 'Please enter the desired subscription id: ' subscription
az account set --subscription $subscription
az account list --output table

echo ''
echo '---'
echo ''

read -p 'Please enter the desired resource group name: ' rsg

echo ''
echo '---'
echo ''

read -p 'Please enter the desired storage account SKU ex. Standard_RAGRS: ' sku

echo ''
echo '---'
echo ''

read -p 'Please enter the desired storage account mane: ' name

echo ''
echo '---'
echo ''

STORAGEACCT=$(az storage account create \
        --resource-group $rsg \
        --name $name$RANDOM \
        --sku $sku \
        --output tsv \
        --query "name")

echo $STORAGEACCT

az storage account show \
        --name $STORAGEACCT \
        --query "[statusOfPrimary, statusOfSecondary]"

az storage account show-connection-string \
        --name $STORAGEACCT \
        --resource-group $rsg

az storage account show \
        --name $STORAGEACCT \
        --expand geoReplicationStats \
        --query "[primaryEndpoints, secondaryEndpoints, geoReplicationStats]"

  # WestUS2 and CentralUS
  #az storage account failover --name $STORAGEACCT
  
  #"connectionString": "DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=healthcareapp8567;AccountKey=F3FzZdvgTdR+Lft608dLU1ErVj95e9eH7vSTAeiro22NtrXIIzLS+rOgaMY8ARm7HHbuyi/0mEIVA66/s+ynMQ=="