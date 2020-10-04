#!/bin/bash

rg=scalesetrg
location=eastus
vmssname=webServerScaleSet

az group create \
  --location $location \
  --name $rg

az vmss create \
  --resource-group $rg \
  --name $vmssname \
  --image UbuntuLTS \
  --upgrade-policy-mode automatic \
  --custom-data cloud-init.yaml \
  --admin-username azureuser \
  --generate-ssh-keys

#Configure the virtual machine scale set
az network lb probe create \
  --lb-name ${vmssname}LB \
  --resource-group $rg \
  --name webServerHealth \
  --port 80 \
  --protocol Http \
  --path /

az network lb rule create \
  --resource-group $rg \
  --name webServerLoadBalancerRuleWeb \
  --lb-name ${vmssname}LB \
  --probe-name webServerHealth \
  --backend-pool-name webServerScaleSetLBBEPool \
  --backend-port 80 \
  --frontend-ip-name loadBalancerFrontEnd \
  --frontend-port 80 \
  --protocol tcp