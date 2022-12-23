#!/bin/bash

REGISTRY_NAME="[repository name]"
REPOSITORIES=$(az acr repository list --name $REGISTRY_NAME --output tsv)

for repository in $REPOSITORIES
do
    echo "Purging ${repository}..."
    PURGE_CMD="acr purge --filter '${repository}:.*' --untagged --ago 30d"
    az acr run --cmd "$PURGE_CMD" --registry $REGISTRY_NAME /dev/null  
done 