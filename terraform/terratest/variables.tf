variable "location" {
    description = "location of your resource group"
    type        = string
}

variable "netindex" {
    description = "The index that replaces xx in the netrwork range 10.xx.0.0"
    type        = string
    default     = "20"
}

variable "subscriptionID" {
    type = string
    description = "Variable for our resource group"
}

variable "resourceGroupName" {
    type = string
    description = "name of resource group"
}