#!/bin/bash
RESOURCEGROUP=armdeployment
USERNAME=azureuser
PASSWORD=$(openssl rand -base64 32)
DEPLOYMENT=MyDeployment
DNS_LABEL_PREFIX=$DEPLOYMENT-$RANDOM
VMNAME=simpleLinuxVM

az deployment group create \
  --name $DEPLOYMENT \
  --resource-group $RESOURCEGROUP \
  --template-uri "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-simple-linux/azuredeploy.json" \
  --parameters adminUsername=$USERNAME \
  --parameters adminPassword=$PASSWORD \
  --parameters dnsLabelPrefix=$DNS_LABEL_PREFIX

az vm extension set \
  --resource-group $RESOURCEGROUP \
  --vm-name $VMNAME \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --settings '{"fileUris":["https://raw.githubusercontent.com/MicrosoftDocs/mslearn-welcome-to-azure/master/configure-nginx.sh"]}' \
  --protected-settings '{"commandToExecute": "./configure-nginx.sh"}'

cat $PASSWORD