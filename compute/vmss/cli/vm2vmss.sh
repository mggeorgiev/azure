#!/bin/bash

## ssh to the vm and run sudo waagent -deprovision+user

myResourceGroup="myResourceGroup"
myVM="myVM"
myImage="myImage"
MyVmss="MyVmss"


az vm deallocate \
    --resource-group $myResourceGroup \
    --name $myVM

az vm generalize \
    --resource-group $myResourceGroup \
    --name $myVM

az image create \
    --resource-group $myResourceGroup \
    --name $myImage --source $myVM

az vmss create \
    --name $MyVmss \
    --resource-group $myResourceGroup \
    --generate-ssh-keys \
    --instance-count=2 \
    --image $myImage

az vmss scale \
    --name $MyVmss \
    --new-capacity 3 \
    --resource-group $myResourceGroup