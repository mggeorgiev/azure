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

read -p 'Please enter the desired service principal name: ' servicePrincipalName

echo ''
echo '---'
echo ''

PASSWORD=$(az ad sp create-for-rbac --name $servicePrincipalName --skip-assignment --querry '{password} --output tsv')
echo $PASSWORD


APP_ID=$(az ad sp list --display-name $servicePrincipalName --query '[].{App_ID:appId}' --output tsv)
echo $APP_ID
echo ''
echo '---'
echo ''


#Request the Access Token
#Get the required information from:
#az account list --output table --query '[].{Name:name, SubscriptionId:id, TenantId:tenantId}' for all or

Name=$(az account show -s $subcription --output tsv --query '{Name:name}')
SubscriptionId=$(az account show -s $subcription --output tsv --query '{SubscriptionId:id}')
TenantId=$(az account show -s $subcription --output tsv --query '{TenantId:tenantId}')


#tocken=$(curl -X POST -d 'grant_type=client_credentials&client_id=$APP_ID&client_secret=$PASSWORD&resource=https%3A%2F%2Fmanagement.azure.com%2F' https://login.microsoftonline.com/[TENANT_ID]/oauth2/token)