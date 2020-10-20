variable location {
    description = "The location of the AKS Cluster solution."
    default     = "westeurope"
}
variable resource_group_name {
    description = "The name of the Azure Resource Group."
    default     = "rsg-kudosboards-p-01"
}
variable log_analytics_workspace_name {
    description = "The name of the Log Analytics workspace."
    default     = "law-kudosaksmonitor-p-01"
}
# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    description = "The location of the Log Analytics workspace."
    default     = "westeurope"
}
# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    description = "The pricing SKU of the Log Analytics workspace."
    default     = "PerGB2018"
}
variable aks_cluster_name {
    description = "The name of the AKS cluster resource."
    default     = "kudosBoardsCluster"
}
variable "public_ssh_key_path" {
    description = "The Path at which your Public SSH Key is located. "
    # Generate SSH keys (This will overwrite any existing key called 'id_rsa') yes y | ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa"
    default     = "~/.ssh/id_rsa.pub"
}