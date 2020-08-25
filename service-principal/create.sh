#!/bin/bash

az login
az account list --output table

az account set --subsctiption $subscription

az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$subscription" --name="Azure-DevOps" 
