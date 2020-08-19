#!/bin/bash

az account list-locations --output table

source windows.cfg

#Create Azure Migrate resource group

az group create --name $rg --location $location

#NW
az network vnet create --address-prefixes 10.$nwindex.0.0/16 --name $rg-vnet --resource-group $rg --subnet-name default --subnet-prefixes 10.$nwindex.0.0/24

az network vnet subnet create -g $rg --vnet-name $rg-vnet -n AzureBastionSubnet \
    --address-prefixes 10.$nwindex.1.0/24 #--network-security-group $rg-Nsg --route-table {$rg}RouteTable

az network public-ip create -g $rg -n Bastion-PIP --sku Standard
    
az network bastion create --location $location --name $rg-bastionhost --public-ip-address Bastion-PIP --resource-group $rg --vnet-name $rg-vnet
