#!/bin/bash

# the approach assumes that the user running the command has the required permissions on both the source and the target Azure key vault
keyvaultURI=""
targetVaultName=""

#az keyvault secret list --id $keyvaultURI --query "[].name" --output tsv

az keyvault secret list --id $keyvaultURI --query "[].id" --output tsv

secrets=($(az keyvault secret list --id $keyvaultURI --query '[].id' --output tsv))

for i in ${!secrets[@]};
do
    echo "Working on ${secrets[$i]}"

    #secretName=$(az keyvault secret show --id ${secrets[$i]} --query 'name')
    #value=$(az keyvault secret show --id ${secrets[$i]} --query 'value')

    ### or this apporach that reduces the api calls but requires jq

    json=$(az keyvault secret show --id ${secrets[$i]})
    echo $json | jq

    secretName=$($json | jq .name --raw-output)
    value=$($json | jq .value --raw-output)

    az keyvault secret set --name $secretName --vault-name $targetVaultName --value $value
done