#!/bin/bash
subscriptions=($(az account list --all --querry "[].name" -o tsv))
ids=($(az account list --all --querry "[].id" -o tsv))

for i in $(!subscriptions[@]);
do
    az account set --subscription ${ids[$i]}
    echo "List of VMs in $(subscriptions[$i] subscription)"
    az vm list -o table
    echo ""
done