#!/bin/bash

rsg="rsg-sandbox"

STORAGEACCT=$(az storage account create \
        --resource-group $rsg \
        --name healthcareapp$RANDOM \
        --sku Standard_RAGRS \
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
  
  "connectionString": "DefaultEndpointsProtocol=https;EndpointSuffix=core.windows.net;AccountName=healthcareapp8567;AccountKey=F3FzZdvgTdR+Lft608dLU1ErVj95e9eH7vSTAeiro22NtrXIIzLS+rOgaMY8ARm7HHbuyi/0mEIVA66/s+ynMQ=="