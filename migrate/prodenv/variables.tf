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

# variable "private_key_path" {
#     type = string
#     default = "/home/user/.ssh/terraform_rsa"
# }

# variable "public_key" {
#     type = string
#     default = "ssh-rsa terraform_public_key"
# }

# variable "zones" {
#     type = map
#     default = {
#         "amsterdam" = "nl-ams1"
#         "london"    = "uk-lon1"
#         "frankfurt" = "de-fra1"
#         "helsinki1" = "fi-hel1"
#         "helsinki2" = "fi-hel2"
#         "chicago"   = "us-chi1"
#         "sanjose"   = "us-sjo1"
#         "singapore" = "sg-sin1"
#     }
# }

# variable "templates" {
#     type = map
#     default = {
#         "ubuntu18" = "01000000-0000-4000-8000-000030080200"
#         "centos7"  = "01000000-0000-4000-8000-000050010300"
#         "debian9"  = "01000000-0000-4000-8000-000020040100"
#     }
# }

# variable "set_password" {
#     type = boolean
#     default = false
# }

variable "users" {
    type = list
    default = ["root", "azureuser"] 
}