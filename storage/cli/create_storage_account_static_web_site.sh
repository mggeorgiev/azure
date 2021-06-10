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

read -p 'Please enter the desired storage account name: ' name

echo ''
echo '---'
echo ''

read -p 'Please enter the desired storage account location: ' LOCATION

echo ''
echo '---'
echo ''

az group create -n $rsg -l $LOCATION

STORAGE_ACC_NAME=$(az storage account create \
        --resource-group $rsg \
        --name $name$RANDOM \
        --sku $sku \
        --output tsv \
        --query "name")

echo $STORAGE_ACC_NAME

az storage account show \
        --name $STORAGE_ACC_NAME \
        --query "[statusOfPrimary, statusOfSecondary]"

az storage account show-connection-string \
        --name $STORAGE_ACC_NAME \
        --resource-group $rsg

az storage account show \
        --name $STORAGE_ACC_NAME \
        --expand geoReplicationStats \
        --query "[primaryEndpoints, secondaryEndpoints, geoReplicationStats]"

az storage blob service-properties update --account-name $STORAGE_ACC_NAME --static-website --404-document error.html --index-document index.html