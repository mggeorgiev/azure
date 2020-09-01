terraform {
  backend "azurerm" {
      resource_group_name   = "tstate"
      storage_account_name  = "tstate7824"
      container_name        = "tstate"
      key                   = "terraform.tfstate"
  }
}

provider "azurerm" {
  version = "~>2.0"
  features {}
}

# Create Hub-Spoke Resource Group
resource "azurerm_resource_group" "rghubspoke" {
    name                = var.rgHubPpoke["resource_group_name"]
    location            = var.rgHubPpoke["location"]

    tags = {
        environment     = var.rgHubPpoke["environment"],
        billing-code    = var.rgHubPpoke["billing-code"]
    }
}

# Create hub virtual network
resource "azurerm_virtual_network" "vnetHub" {
    name                  = var.vnetHub["name"]
    address_space         = ["${var.vnetHub["address_space"]}"]
    location              = azurerm_resource_group.rghubspoke.location
    resource_group_name   = azurerm_resource_group.rghubspoke.name

    tags = {
        environment       = var.vnetHub["environment"],
        billing-code      = var.vnetHub["billing-code"]
    }
}

# Create subnet for AzureBastionHost
resource "azurerm_subnet" "hubAzureBastionHostSubnet" {
    name                 = "AzureBastionSubnet"
    resource_group_name  = azurerm_resource_group.rghubspoke.name
    virtual_network_name = azurerm_virtual_network.vnetHub.name
    address_prefixes     = ["${var.vnetHub["AzureBastionSubnet"]}"]
}

# Create subnet
resource "azurerm_subnet" "hubSubnet" {
    name                 = "hub-subnet"
    resource_group_name  = azurerm_resource_group.rghubspoke.name
    virtual_network_name = azurerm_virtual_network.vnetHub.name
    address_prefixes     = ["${var.vnetHub["defaultSubnet"]}"]
}

# Create spoke1 virtual network
resource "azurerm_virtual_network" "vnetSpoke1" {
    name                = var.vnetSpoke1["name"]
    address_space       = ["${var.vnetSpoke1["address_space"]}"]
    location            = azurerm_resource_group.rghubspoke.location
    resource_group_name = azurerm_resource_group.rghubspoke.name

    tags = {
        environment     = var.vnetHub["environment"],
        billing-code    = var.vnetHub["billing-code"]
    }
}

# Create subnet for AzureBastionHost
resource "azurerm_subnet" "spokeAzureBastionHostSubnet1" {
    name                 = "AzureBastionSubnet"
    resource_group_name  = azurerm_resource_group.rghubspoke.name
    virtual_network_name = azurerm_virtual_network.vnetSpoke1.name
    address_prefixes     = ["${var.vnetSpoke1["AzureBastionSubnet"]}"]
}

# Create subnet
resource "azurerm_subnet" "spoke1Subnet" {
    name                 = "spoke1-subnet"
    resource_group_name  = azurerm_resource_group.rghubspoke.name
    virtual_network_name = azurerm_virtual_network.vnetSpoke1.name
    address_prefixes     = ["${var.vnetSpoke1["defaultSubnet"]}"]
}

# Create spoke2 virtual network
resource "azurerm_virtual_network" "vnetSpoke2" {
    name                = var.vnetSpoke2["name"]
    address_space       = ["${var.vnetSpoke2["address_space"]}"]
    location            = azurerm_resource_group.rghubspoke.location
    resource_group_name = azurerm_resource_group.rghubspoke.name

    tags = {
        environment     = var.vnetHub["environment"],
        billing-code    = var.vnetHub["billing-code"]
    }
}

# Create subnet for AzureBastionHost
resource "azurerm_subnet" "spokeAzureBastionHostSubnet2" {
    name                 = "AzureBastionSubnet"
    resource_group_name  = azurerm_resource_group.rghubspoke.name
    virtual_network_name = azurerm_virtual_network.vnetSpoke2.name
    address_prefixes     = ["${var.vnetSpoke2["AzureBastionSubnet"]}"]
}

# Create subnet
resource "azurerm_subnet" "spoke2Subnet" {
    name                 = "spoke2-subnet"
    resource_group_name  = azurerm_resource_group.rghubspoke.name
    virtual_network_name = azurerm_virtual_network.vnetSpoke2.name
    address_prefixes     = ["${var.vnetSpoke2["defaultSubnet"]}"]
}

resource "azurerm_virtual_network_peering" "hub2spoke1" {
  name                      = "hub2spoke1"
  resource_group_name       = azurerm_resource_group.rghubspoke.name
  virtual_network_name      = azurerm_virtual_network.vnetHub.name
  remote_virtual_network_id = azurerm_virtual_network.vnetSpoke1.id
}

resource "azurerm_virtual_network_peering" "hub2spoke2" {
  name                      = "hub2spoke2"
  resource_group_name       = azurerm_resource_group.rghubspoke.name
  virtual_network_name      = azurerm_virtual_network.vnetHub.name
  remote_virtual_network_id = azurerm_virtual_network.vnetSpoke2.id
}
