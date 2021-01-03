accountName=""
resourceGroup=""

key=$(az storage account keys list -n $accountName -g $resourceGroup --query "[*] | [0].value")
az storage container show  --account-name $accountName --account-key $key --name "\$logs"
az storage blob download-batch --destination . --source "\$logs" --account-name $accountName --account-key $key