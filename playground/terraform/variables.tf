# variables.tf

variable "resource_group" {
    type = string
    default = "playground"
}

variable "location" {
    type = string
    default = "eastus"
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
        "East US"       = "eastus"
        "West Europe"   = "uk-lon1"
        "frankfurt"     = "de-fra1"
        "helsinki1"     = "fi-hel1"
        "helsinki2"     = "fi-hel2"
        "chicago"       = "us-chi1"
        "sanjose"       = "us-sjo1"
        "singapore"     = "sg-sin1"
    }
}

variable "vmnamelinux" {
    type = string
    default = "linux"
}

variable "vmnamewindows" {
    type = string
    default = "windows"
}

variable "users" {
    type = list
    default = ["root", "azureuser"] 
}
