# variables.tf

variable "subscriptionID" {
    type = string
    description = "The targer subscription id"
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

variable "environementtag" {
    type = string
    default = "playground"
}

variable "billing-code" {
    type = string
    default = "010"
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
