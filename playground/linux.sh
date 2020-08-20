#!/bin/bash

az account list-locations --output table

#Load variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd -- $DIR

source linux.cfg

az vm create \
    --resource-group myResourceGroupVM \
    --name myVM \
    --image $vmimage \
    --admin-username azureuser \
    --generate-ssh-keys
