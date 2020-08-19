#!/bin/bash

az account list-locations --output table

#Create Azure Migrate resource group
source windows.cfg

az group create --name {$rg} --location {$location}

#NW
az network vnet create --address-prefixes 10.$nwindex.0.0/16 --name $rg-vnet --resource-group $rg --subnet-name default --subnet-prefixes 10.$nwindex.0.0/24

az network vnet subnet create -g $rg --vnet-name $rg-vnet -n AzureBastionSubnet \
    --address-prefixes 10.$nwindex.1.0/24 #--network-security-group $rg-Nsg --route-table {$rg}RouteTable

az network public-ip create -g $rg -n $rg-Bastion-PIP --sku Standard
    
az network bastion create --location $location --name $rg-bastionhost --public-ip-address $rg-Bastion-PIP --resource-group $rg --vnet-name $rg-vnet

az network public-ip create -g $rg -n AzureMigratPhysicalAppliance-PIP --sku Standard

az vm create --name {$vmname} \
    --resource-group {$rg} \
    --computer-name {$computername} \
    --image win2016datacenter  \
    --authentication-type password \
    --admin-username {$adminusername} \
    --admin-password {$adminpassword} \
    --license-type Windows_Server \
    --vnet-name {$rg}-vnet \
    --subnet default \
    --public-ip-address {$vmname}-PIP \
    --size Standard_D2s_v3 
