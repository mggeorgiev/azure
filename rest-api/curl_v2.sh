#!/bin/bash

read -p 'Please enter the desired subscription id: ' subscription
az account set --subscription $subscription
az account list --output table

echo ''
echo '---'
echo ''

### create a service principal using ./../service-principal
#or
#az ad sp create-for-rbac --name [APP_NAME] --password [CLIENT_SECRET]


Name=$(az account show -s $subcription --output tsv --query '{Name:name}')
SubscriptionId=$(az account show -s $subcription --output tsv --query '{SubscriptionId:id}')
#SubscriptionId=$(az account list | jq ".[] | select (.name == \"${Name}\") | .id" -r)
TenantId=$(az account show -s $subcription --output tsv --query '{TenantId:tenantId}')

#Request the Access Token
response=$(az account get-access-token)
token=$(echo $response | jq ".accessToken" -r)

curl -X GET -H "Authorization: Bearer $token" -H "Content-Type:application/json" -H "Accept:application/json" https://management.azure.com/subscriptions/$subid/providers/Microsoft.Web/sites\?api-version\=2016-08-01 | jq .