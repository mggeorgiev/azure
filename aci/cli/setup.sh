DNS_NAME_LABEL=aci-demo-$RANDOM

az container create \
  --resource-group $rg \
  --name $container \
  --image microsoft/aci-helloworld \
  --ports 80 \
  --dns-name-label $DNS_NAME_LABEL \
  --restart-policy OnFailure \
  --location $location

#   --environment-variables \
#or
#  --secure-environment-variables \
#     COSMOS_DB_ENDPOINT=$COSMOS_DB_ENDPOINT \
#     COSMOS_DB_MASTERKEY=$COSMOS_DB_MASTERKEY

#   --azure-file-volume-account-name $STORAGE_ACCOUNT_NAME \
#   --azure-file-volume-account-key $STORAGE_KEY \
#   --azure-file-volume-share-name aci-share-demo \
#   --azure-file-volume-mount-path /aci/logs/

az container show \
  --resource-group $rg \
  --name $container \
  --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" \
  --out table

az container logs \
  --resource-group $rg \
  --name $container

az container show \
  --resource-group  $rg \
  --name $container \
  --query ipAddress.ip \
  --output tsv

az container exec \
  --resource-group $rg \
  --name $container \
  --exec-command /bin/sh

CONTAINER_ID=$(az container show \
    --resource-group $rg \
    --name $container \
    --query id \
    --output tsv)

az monitor metrics list \
    --resource $CONTAINER_ID \
    --metric CPUUsage \
    --output table


