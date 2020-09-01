#!/bin/bash

az network vnet create --name hub --resource-group test --address-prefixes 10.50.0.0/16
az network vnet create --name spoke1 --resource-group test --address-prefixes 10.51.0.0/16
az network vnet create --name spoke2 --resource-group test --address-prefixes 10.52.0.0/16

az network nsg create --resource-group test --name hubNsg
az network nsg create --resource-group test --name spoke1Nsg
az network nsg create --resource-group test --name spoke2Nsg

az network vnet subnet create --resource-group test --vnet-name hub --name default --address-prefixes 10.50.0.0/24
az network vnet subnet create --resource-group test --vnet-name spoke1 --name default --address-prefixes 10.51.0.0/24
az network vnet subnet create --resource-group test --vnet-name spoke2 --name default --address-prefixes 10.52.0.0/24

az network vnet subnet create --resource-group test --vnet-name hub --name AzureBastionSubnet --address-prefixes 10.50.1.0/24
az network vnet subnet create --resource-group test --vnet-name spoke1 --name AzureBastionSubnet --address-prefixes 10.51.1.0/24
az network vnet subnet create --resource-group test --vnet-name spoke2 --name AzureBastionSubnet --address-prefixes 10.52.1.0/24

az network nic create --resource-group test --name hubNic --network-security-group hubNsg --subnet default
az network nic create --resource-group test --name spoke1Nic --network-security-group hubNsg --subnet default
az network nic create --resource-group test --name spoke2Nic --network-security-group hubNsg --subnet default

az network nic create --name hubNic --resource-group test --vnet-name hub --subnet default --network-security-group hubNsg
az network nic create --name spoke1Nic --resource-group test --vnet-name spoke1 --subnet default --network-security-group spoke1Nsg
az network nic create --name spoke2Nic --resource-group test --vnet-name spoke2 --subnet default --network-security-group spoke2Nsg
