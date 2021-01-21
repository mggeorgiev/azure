gitRepo=https://github.com/MicrosoftDocs/mslearn-capture-application-logs-app-service
appName="contosofashions$RANDOM"
appPlan="contosofashionsAppPlan"
appLocation="westeurope"
resourceGroup="rsg-webapp-weu-p-001"
storageAccount=sa$appName

az appservice plan create --name $appPlan --resource-group $resourceGroup --location $appLocation --sku FREE
az webapp create --name $appName --resource-group $resourceGroup --plan $appPlan --deployment-source-url $gitRepo

az storage account create -n $storageAccount -g $resourceGroup -l $appLocation --sku Standard_LRS


### view the application log
#az webapp log tail --name $appName --resource-group $resourceGroup

userName="myUserName" ##globally unique
password="MyStrongPassword"
###create user credentials 
#az webapp deployment user set --user-name $userName --password $password
#curl -u $userName https://$appName.scm.azurewebsites.net/api/logstream

###download logs
az webapp log download --log-file log.zip  --resource-group $resourceGroup --name $appName
zipinfo -1 log.zip