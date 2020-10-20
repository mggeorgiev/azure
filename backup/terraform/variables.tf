# variables.tf

variable "subscriptionID" {
    type = string
}

variable "resource_group" {
    type = string
    #default = "rg-rsv"
}

variable "location" {
    type = string
    #default = "eastus"
}

variable "rsvault" {
    type    = string
    #default = "rvt-playgound-002"
}

variable "environementtag" {
    type = string
    #default = "infra"
}

variable "billing-code" {
    type = string
    #default = "010"
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