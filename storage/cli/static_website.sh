#!/bin/bash

subscription=""
resourceGroup=""
rolename=""
storageAccountname=""
location=westeurope

az account set -s $subscription
subscriptionId=$(az account show --query id --output tsv)

az group create --name $resourceGroup --location $location


az ad sp create-for-rbac --name $rolename --role contributor --scopes /subscriptions/${subscriptionId}/resourceGroups/${resourceGroup} --sdk-auth

az storage account create --name $storageAccountname \ 
                          --resource-group $resourceGroup \
                          --access-tier Hot \
                          --location $location \
                          --sku Standard_LRS \
                          --subscription $subscription

az storage blob service-properties update \
                                    --account-name $storageAccountname \
                                    --static-website --index-document index.html \
                                    --resource-group $resourceGroup \
                                    --location $location

origin=$(az storage account show -g $resourceGroup -n $storageAccountname --query primaryEndpoints.web --output tsv)

az cdn profile create -n $rolename --sku Standard_Microsoft

az cdn endpoint create -n ${rolename}cdnendpoint --profile-name $rolename --origin $origin --origin-host-header $origin --enable-compression
