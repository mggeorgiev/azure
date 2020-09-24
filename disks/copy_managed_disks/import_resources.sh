#!/bin/bash

RESOURCE_GROUP_NAME="rsg-migtest-weu1-d-02"
subscription="fdc9bd0d-e27f-4689-b2de-e8a1df3babf9"
source="lubtzweb11_1-lubtzweb11-test"
vmname="vmteuweweb11"

touch main.tf

echo '' >> main.tf
echo 'provider "azurerm" {' >> main.tf
echo '  version = "~>2.0"' >> main.tf
echo '  features {}' >> main.tf
echo '}' >> main.tf
echo '' >> main.tf

terraform init

az group show --name $RESOURCE_GROUP_NAME --subscription $subscription
rgid=$(az group show --name $RESOURCE_GROUP_NAME --subscription $subscription --query id --output tsv)
location=$(az group show --name $RESOURCE_GROUP_NAME --subscription $subscription --query location --output tsv)

echo 'resource "azurerm_resource_group" "resource_group" {" >> main.tf
echo "  name     = \"${RESOURCE_GROUP_NAME}\"" >> main.tf
echo "  location = \"${location}\"" >> main.tf
echo '}' >> main.tf
echo '' >> main.tf


terraform import azurerm_resource_group.resource_group /subscriptions/${subscription}/resourceGroups/${RESOURCE_GROUP_NAME}

terraform init

az group show --name $RESOURCE_GROUP_NAME --subscription $subscription
rgid=$(az group show --name $RESOURCE_GROUP_NAME --subscription $subscription --query id --output tsv)
location=$(az disk show --subscription $subscription --resource-group $RESOURCE_GROUP_NAME --name $source --query location --output tsv)


echo 'resource "azurerm_managed_disk" "source" {' >> main.tf
echo '   name                 = "$source"' >> main.tf
echo "   location             = \"${location}\"" >> main.tf
echo '   resource_group_name  = azurerm_resource_group.resource_group.name' >> main.tf
echo '   storage_account_type = "Standard_LRS"' >> main.tf
echo '   create_option        = "Empty"' >> main.tf
echo '   disk_size_gb         = "1"' >> main.tf

echo '   tags = {' >> main.tf
echo '     environment = "staging"' >> main.tf
echo '   }' >> main.tf
echo '}' >> main.tf
echo '' >> main.tf

terraform import azurerm_managed_disk.source $(az disk show --subscription $subscription --resource-group $RESOURCE_GROUP_NAME --name $source --query id --output tsv)

terraform init

# resource "azurerm_managed_disk" "copy" {
# echo "   name                 = \"${vmname}-osd01\"" >> main.tf
# echo "   location             = \"${location}\"" >> main.tf
# echo "   resource_group_name  = azurerm_resource_group.resource_group.name" >> main.tf
# echo "   storage_account_type = azurerm_managed_disk.source.storage_account_type" >> main.tf
# echo '   create_option        = "Copy"' >> main.tf
# echo '   source_resource_id   = azurerm_managed_disk.source.id' >> main.tf
# echo '   disk_size_gb         = "1"' >> main.tf

# echo '   tags = {' >> main.tf
# echo '     environment = "staging"' >> main.tf
# echo '   }' >> main.tf
# echo '}' >> main.tf
# echo '' >> main.tf

# terraform init
