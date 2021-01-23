variable "resource_group_name" {
    type    = string
}

variable "resource_group_location" {
    type    = string
    default = "westeurope"
}

variable "address_space" {
    type=list(string)
    default = ["10.4.0.0/16"]
}

variable "address_prefixes" {
    type=list(string)
    default=["10.4.0.0/24"]
}

variable "gw_address_prefixes" {
    type=list(string)
    default=["10.4.255.0/27"]
}

variable "local_address_space" {
    type=list(string)
    default = ["192.168.88.0/24"]
}

variable "onprempip" {
    type = string
}

variable "shared_key" {
    type = string
}

variable "gw_sku" {
    type    = string
    default = "Basic"
}

variable "gateway_name" {
    type    = string
}

variable "local_gateway_name" {
    type    = string
}

variable "connection_name" {
    type    = string
}
