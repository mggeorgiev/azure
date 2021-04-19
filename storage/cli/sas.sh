#!/bin/bash

read -p 'Please enter the desired subscription id: ' subscription
az account set --subscription $subscription
az account list --output table

echo ''
echo '---'
echo ''

read -p 'Please enter the desired account name: ' account_name
echo ''
echo '---'
echo ''

read -p 'Please enter the desired permissions the SAS grants. Allowed values: (a)dd (c)reate (d)elete (l)ist (p)rocess (r)ead (u)pdate (w)rite. Can be combined: ' permissions

echo ''
echo '---'
echo ''

read -p 'Please enter the desired storage services. Allowed values: (b)lob (f)ile (q)ueue (t)able. Can be combined: ' services

echo ''
echo '---'
echo ''

end=`date -u -d "30 minutes" '+%Y-%m-%dT%H:%MZ'`
az storage account generate-sas --permissions $permissions --account-name $account_name --services $services --resource-types sco --expiry $end -o tsv