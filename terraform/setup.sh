#!/bin/bash

RESOURCE_GROUP_NAME=tstate
STORAGE_ACCOUNT_NAME=tstate$RANDOM
CONTAINER_NAME=tstate
location=eastus

# Create resource group
if [ $(az group exists --name ${RESOURCE_GROUP_NAME}) = false ]; then
    echo "Create resource group: ${RESOURCE_GROUP_NAME}"
    az group create --name $RESOURCE_GROUP_NAME --location $location
fi

echo "Create Key Vault: ${STORAGE_ACCOUNT_NAME}"
az keyvault create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --location $location

# Create storage account
echo "Create Storage account: ${STORAGE_ACCOUNT_NAME}"
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

az keyvault secret set --vault-name $STORAGE_ACCOUNT_NAME --name terraform-backend-key --value $ACCOUNT_KEY


# Create blob container
echo "Create storage container: ${CONTAINER_NAME}"
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "storage_account_name: ${STORAGE_ACCOUNT_NAME}"
echo "container_name: ${CONTAINER_NAME}"
echo "key_vault_name: ${STORAGE_ACCOUNT_NAME}"
echo "Secret name: terraform-backend-key"

#Create a directory if it does not exists
dir=~/clouddrive/terraformbackend
mkdir -p $dir

# if [[ ! -e $dir ]]; then
#     mkdir $dir
# elif [[ ! -d $dir ]]; then
#     echo "$dir already exists but is not a directory" 1>&2
# fi

touch ${dir}/terraformbackend.tf

echo 'terraform {' > ${dir}/terraformbackend.tf
echo '  backend "azurerm" {' >> ${dir}/terraformbackend.tf
echo "    resource_group_name   = \"${RESOURCE_GROUP_NAME}\"" >> ${dir}/terraformbackend.tf
echo "    storage_account_name  = \"${STORAGE_ACCOUNT_NAME}\"" >> ${dir}/terraformbackend.tf
echo "    container_name        = \"${CONTAINER_NAME}\"" >> ${dir}/terraformbackend.tf
echo '    key                   = "terraform.tfstate"' >> ${dir}/terraformbackend.tf
echo '  }' >> ${dir}/terraformbackend.tf
echo '}' >> ${dir}/terraformbackend.tf
echo '' >> ${dir}/terraformbackend.tf
echo 'resource "azurerm_resource_group" "state-demo-secure" {' >> ${dir}/terraformbackend.tf
echo '  name     = "state-demo"' >> ${dir}/terraformbackend.tf
echo "  location = \"${location}\"" >> ${dir}/terraformbackend.tf
echo '}' >> ${dir}/terraformbackend.tf
echo '' >> ${dir}/terraformbackend.tf
echo 'provider "azurerm" {' >> ${dir}/terraformbackend.tf
echo '  version = "~>2.0"' >> ${dir}/terraformbackend.tf
echo '  features {}' >> ${dir}/terraformbackend.tf
echo '}' >> ${dir}/terraformbackend.tf
