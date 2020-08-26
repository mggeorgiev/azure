#!/bin/bash
#consult https://medium.com/@gmusumeci/deploying-terraform-infrastructure-using-azure-devops-pipelines-step-by-step-advanced-1281b4ee15d1

az login
az account list --output table

az account set --subsctiption $subscription

az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$subscription" --name="Azure-DevOps"

#appId (Azure) → client_id (Terraform).
#password (Azure) → client_secret (Terraform).
#tenant (Azure) → tenant_id (Terraform).

#https://marketplace.visualstudio.com/items?itemName=charleszipp.azure-pipelines-tasks-terraform
