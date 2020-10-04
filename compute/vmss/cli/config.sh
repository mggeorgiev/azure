#!/bin/bash

rg=scalesetrg
location=eastus
vmssname=webServerScaleSet

#manual scale
az vmss scale \
    --name $vmssname \
    --resource-group $rg \
    --new-capacity 6

