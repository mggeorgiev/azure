#!/bin/bash

read -p 'Please enter the desired subscription id. Leave blank for default: ' subscription

if [ $subscription="yes" ]; then
        az account set --subscription $subscription
        az account list --output table
fi

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
AZURE_STORAGE_SAS_TOKEN=(az storage account generate-sas --account-key 00000000 --https-only --permissions $permissions --account-name $account_name --services $services --resource-types sco --expiry $end -o tsv)

echo $AZURE_STORAGE_SAS_TOKEN