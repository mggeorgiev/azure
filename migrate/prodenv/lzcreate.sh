#!/bin/bash

az account list-locations --output table

#Create Azure Migrate resource group
rg=AzureMigrate
location=eastus
nwindex=10

az group create --name $rg --location $location

#NW
az network vnet create --address-prefixes 10.$nwindex.0.0/16 --name $rg-vnet --resource-group $rg --subnet-name default --subnet-prefixes 10.$nwindex.0.0/24

az network vnet subnet create -g $rg --vnet-name $rg-vnet -n AzureBastionSubnet \
    --address-prefixes 10.$nwindex.1.0/24 #--network-security-group $rg-Nsg --route-table {$rg}RouteTable

az network public-ip create -g $rg -n Bastion-PIP --sku Standard
    
az network bastion create --location $location --name $rg-bastionhost --public-ip-address $rg-Bastion-PIP --resource-group $rg --vnet-name $rg-vnet


az vm create --name AzureMigratPhysicalAppliance \
    --resource-group $rg \
    --computer-name azmgrpa \
    --image win2016datacenter  \
    --authentication-type password \
    --admin-username azureuser \
    --admin-password 4wPcRFreYIVfCUYros9a \
    --license-type Windows_Server \
    --vnet-name $rg-vnet \
    --subnet default \
    --public-ip-address "" \
    --size Standard_D2s_v3 


#Create Azure Migrate resource group
rg=Source
location=eastus
nwindex=11

az group create --name $rg --location $location

#NW
az network vnet create --address-prefixes 10.$nwindex.0.0/16 --name $rg-vnet --resource-group $rg --subnet-name default --subnet-prefixes 10.$nwindex.0.0/24

az network vnet subnet create -g $rg --vnet-name $rg-vnet -n AzureBastionSubnet \
    --address-prefixes 10.$nwindex.1.0/24 #--network-security-group $rg-Nsg --route-table {$rg}RouteTable

az network public-ip create -g $rg -n Bastion-PIP --sku Standard
    
az network bastion create --location $location --name $rg-bastionhost --public-ip-address $rg-Bastion-PIP --resource-group $rg --vnet-name $rg-vnet

#az vm image list --all

az vm create --name kvmhprvsr \
    --resource-group $rg \
    --computer-name kvmhprvsr \
    --image UbuntuLTS \
    --authentication-type password \
    --admin-username azureuser \
    --admin-password 4wPcRFreYIVfCUYros9a \
    --data-disk-sizes-gb 10 20 \
    --size Standard_DS2_v2 
    
#Create Azure Migrate resource group
rg=Target
location=eastus
nwindex=12

#Create Azure Migrate resource group
az group create --name $rg --location $location

#NW
az network vnet create --address-prefixes 10.$nwindex.0.0/16 --name $rg-vnet --resource-group $rg --subnet-name default --subnet-prefixes 10.$nwindex.0.0/24

az network vnet subnet create -g $rg --vnet-name $rg-vnet -n AzureBastionSubnet \
    --address-prefixes 10.$nwindex.1.0/24 #--network-security-group $rg-Nsg --route-table {$rg}RouteTable

az network public-ip create -g $rg -n Bastion-PIP --sku Standard
    
az network bastion create --location $location --name $rg-bastionhost --public-ip-address $rg-Bastion-PIP --resource-group $rg --vnet-name $rg-vnet
