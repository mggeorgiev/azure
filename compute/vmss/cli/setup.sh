rg=scalesetrg
location=westus

az group create \
  --location $location \
  --name $rg

az vmss create \
  --resource-group $rg \
  --name webServerScaleSet \
  --image UbuntuLTS \
  --upgrade-policy-mode automatic \
  --custom-data cloud-init.yaml \
  --admin-username azureuser \
  --generate-ssh-keys

#Configure the virtual machine scale set