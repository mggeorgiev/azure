#!/bin/bash

# {
#   "appId": "720c8af3-3576-43c1-9000-8572ee784a96",
#   "displayName": "mg-terraform-2021-2021-02-05-14-18-22",
#   "name": "http://mg-terraform-2021-2021-02-05-14-18-22",
#   "password": "GrjnFsbTNSr7~CuXUey3FZA~vBGRzYEH88",
#   "tenant": "1624e359-0f5d-4362-af64-e87e9f528420"
# }

tenant="1624e359-0f5d-4362-af64-e87e9f528420" #$(az ad sp list --display-name $sp_name --query [].tenant --output tsv)
password="GrjnFsbTNSr7~CuXUey3FZA~vBGRzYEH88"
service_principal_name="http://mg-terraform-2021-2021-02-05-14-18-22"

az login --service-principal -u $service_principal_name -p $password --tenant $tenant