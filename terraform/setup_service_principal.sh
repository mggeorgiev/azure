#!/bin/bash

subscription_id="79e0f674-0cb6-49bd-9a93-c5be11b8d1b6"
sp_name="mg-terraform-$(date +%Y)-$(date +%Y-%m-%d-%H-%M-%S)"

az ad sp create-for-rbac --name $sp_name --role="Contributor" --scopes="/subscriptions/$subscription_id"

echo 'Note down the output of the command'