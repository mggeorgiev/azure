#!/bin/bash

az account list-locations --output table

#Load variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd -- $DIR

source linux.cfg

az group create --name $rg --location $location

az vm image list --output table
az vm image list --offer UbuntuServer --all --output table
az vm list-sizes --location $location --output table

#NW
az network vnet create --address-prefixes 10.$nwindex.0.0/16 --name $rg-vnet --resource-group $rg --subnet-name default --subnet-prefixes 10.$nwindex.0.0/24

az network vnet subnet create -g $rg --vnet-name $rg-vnet -n AzureBastionSubnet \
    --address-prefixes 10.$nwindex.1.0/24 #--network-security-group $rg-Nsg --route-table {$rg}RouteTable

az network public-ip create -g $rg -n $rg-Bastion-PIP --sku Standard
    
az network bastion create --location $location --name $rg-bastionhost --public-ip-address $rg-Bastion-PIP --resource-group $rg --vnet-name $rg-vnet

az network public-ip create -g $rg -n $vmname-PIP --sku Standard

#Compute
az vm create --name $vmname \
    --resource-group $rg \
    --computer-name $computername \
    --image $vmimage  \
    --authentication-type password \
    --admin-username $adminusername \
    --admin-password $adminpassword \
    --vnet-name $rg-vnet \
    --subnet default \
    --public-ip-address $vmname-PIP \
    --size Standard_D2s_v3 

#Management
az vm list-ip-addresses --resource-group $rg --name $vmname --output table
    
#Resize a VM

#az vm list-sizes --location $location --output table
#az vm show --resource-group $rg --name $vmname --query hardwareProfile.vmSize
#az vm list-vm-resize-options --resource-group $rg --name $vmname --query [].name
#az vm resize --resource-group $rg --name $vmname --size Standard_DS4_v2
#az vm deallocate --resource-group $rg --name $vmname
#az vm resize --resource-group $rg --name $vmname --size Standard_GS1
#az vm start --resource-group $rg --name $vmname

#nwindex=10
