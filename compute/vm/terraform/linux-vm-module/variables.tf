# variables.tf

variable "subscriptionID" {
    type = string
}

variable "resource_group" {
    type = string
    default = "playground"
}

variable "location" {
    type = string
    default = "eastus"
}

variable "zone" {
    type = string
    default = 1
}

variable "vnet_subnet_id" {
    type = string
    description = "Target subnet id"
}

variable "environementtag" {
    type = string
    default = "playground"
}

variable "billing-code" {
    type = string
    default = "010"
}

variable "vmname" {
    type = string
    default = "linux"
}

variable "admin_password" {
    type    = string
    default = "4wPcRFreYIVfCUYros9a"
}

variable "users" {
    type = list
    default = ["root", "azureuser"] 
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

