variable "tfbackend" {
    type = map
    default = {
        "resource_group_name"   = "tstate"
        "storage_account_name"  = "tstate24111"
        "container_name"        = "tstate"
        "key"                   = "terraform.tfstate"
    }
}

variable "rgHubPpoke" {
    type = map
    default = {
        "resource_group_name"   = "hub-spoke"
        "location"              = "eastus"
        "environment"           = "infra"
        "billing-code"          = "010"
    }
}

variable "vnetHub" {
    type = map
    default = {
        "name"                  = "hub-vnet"
        "address_space"         = "10.50.0.0/16"
        "AzureBastionSubnet"    = "10.50.1.0/24"
        "defaultSubnet"         = "10.50.2.0/24"
        "environment"           = "infra"
        "billing-code"          = "010"
    }
}

variable "vnetSpoke1" {
    type = map
    default = {
        "name"                  = "spoke1-vnet"
        "address_space"         = "10.51.0.0/16"
        "AzureBastionSubnet"    = "10.51.1.0/24"
        "defaultSubnet"         = "10.51.2.0/24"        
        "environment"           = "infra"
        "billing-code"          = "010"
    }
}

variable "vnetSpoke2" {
    type = map
    default = {
        "name"                  = "spoke2-vnet"
        "address_space"         = "10.52.0.0/16"
        "AzureBastionSubnet"    = "10.52.1.0/24"
        "defaultSubnet"         = "10.52.2.0/24"           
        "environment"           = "infra"
        "billing-code"          = "010"
    }
}

variable "regions" {
    type = map
    default = {
        "Global"        = "global"
        "Central US"    = "centralus"
        "East US"       = "eastus"
        "East US 2"     = "eastus2"
        "West Europe"   = "westeurope"
        "North Europe"  = "northeurope"
    }
}

variable "namingprefixes" {
    type = map
    default = {
        "global"        = "glob"
        "centralus"     = "cus1"
        "eastus"        = "eus1"
        "eastus2"       = "eus2"
        "westeurope"    = "weu1"
        "northeurope"   = "neu1"
    }
}
