#!/bin/bash

az account list --output table
read -p 'Please enter the desired subscription id: ' subscription
az account set --subscription $subscription
az account list --output table

echo ''
echo '---'
echo ''

az aks list --output table
read -p 'Please enter the resource group name: ' resourceGroup
read -p 'Please enter the aks name: ' aksName

echo ''
echo '---'
echo ''

az aks show --resource-group $resourceGroup --name $aksName --output table
az aks get-upgrades --resource-group $resourceGroup --name $aksName

echo ''
echo '---'
echo ''

read -p 'Target version (you cannot skip major versions): ' KUBERNETES_VERSION
read -p 'To upgrade the cluster type yes: ' upgrade

if [ $upgrade="yes" ]; then
    az aks upgrade \
        --resource-group $resourceGroup \
        --name $aksName \
        --kubernetes-version KUBERNETES_VERSION
fi