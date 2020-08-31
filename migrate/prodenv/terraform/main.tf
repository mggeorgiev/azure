terraform {
  backend "azurerm" {
    resource_group_name   = var.tfstate["resource_group_name"]
    storage_account_name  = var.tfstate["storage_account_name"]
    container_name        = var.tfstate["container_name"]
    key                   = var.tfstate["key"]
  }
}

provider "azurerm" {
  version = "~>2.0"
  features {}
}
