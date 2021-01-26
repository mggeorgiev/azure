#!/bin/bash

vnName="vm1"
resourceGroup=""

cat <<EOF > cloud-init.txt
#cloud-config
package_upgrade: true
packages:
- stress
runcmd:
- sudo stress --cpu 1
EOF

az vm create \
    --resource-group $resourceGroup \
    --name $vnName \
    --image UbuntuLTS \
    --custom-data cloud-init.txt \
    --generate-ssh-keys

VMID=$(az vm show \
        --resource-group $resourceGroup \
        --name $vnName \
        --query id \
        --output tsv)

az monitor metrics alert create \
    -n "Cpu80PercentAlert" \
    --resource-group $resourceGroup \
    --scopes $VMID \
    --condition "max percentage CPU > 80" \
    --description "Virtual machine is running at or greater than 80% CPU utilization" \
    --evaluation-frequency 1m \
    --window-size 1m \
    --severity 3