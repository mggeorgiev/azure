provider "azurerm" {
    version = "~>2.0"
    subscription_id = var.subscriptionID
    features {}
}

resource "azurerm_network_security_group" "OctopusSG" {
  name                = "OctopusSG"
  location            = var.location
  resource_group_name = var.resourceGroupName
}

resource "azurerm_network_security_rule" "Port80" {
  name                        = "Allow80"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.OctopusSG.resource_group_name
  network_security_group_name = azurerm_network_security_group.OctopusSG.name
}

resource "azurerm_network_security_rule" "Port22" {
  name                        = "Allow22"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.OctopusSG.resource_group_name
  network_security_group_name = azurerm_network_security_group.OctopusSG.name
}

resource "azurerm_virtual_network" "octopus-vnet" {
  name                = "octopus-vnet"
  location            = var.location
  resource_group_name = var.resourceGroupName
  address_space       = ["10.${var.netindex}.0.0/16"]
  dns_servers         = ["8.8.8.8", "8.8.4.4"]
}

resource "azurerm_subnet" "octopus-sub" {
  name                 = "testsubnet"
  resource_group_name  = azurerm_network_security_group.OctopusSG.resource_group_name
  virtual_network_name = azurerm_virtual_network.octopus-vnet.name
  address_prefix = "10.${var.netindex}.1.0/24"
}

