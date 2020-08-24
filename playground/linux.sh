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

az vm create \
    --resource-group $rg \
    --name $vmname \
    --image $vmimage \
    --admin-username $adminusername \
    --generate-ssh-keys #  --data-disk-sizes-gb 128 128

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
