variable "resource_group" {
    type    = string
}

variable "address_space" {
    type=list(string)
    default = ["10.10.0.0/16"]
}
variable "address_prefixes" {
    type=list(string)
    default=["10.10.1.0/24"]
}

variable "location" {
    type    = string
    default = "eastus"
}

variable "environementtag" {
    type    = string
}

variable "billing-code" {
    type    = string
}