# Create virtual network
resource "azurerm_virtual_network" "playgroundnetwork" {
    name                = "${var.resource_group}-vnet"
    address_space       = ["10.10.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.playgroundgroup.name

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}

# Create subnet
resource "azurerm_subnet" "playgroundsubnet" {
    name                 = "${var.resource_group}-subnet"
    resource_group_name  = azurerm_resource_group.playgroundgroup.name
    virtual_network_name = azurerm_virtual_network.playgroundnetwork.name
    address_prefixes       = ["10.10.1.0/24"]
}

# Create subnet for AzureBastionHost
resource "azurerm_subnet" "playgroundazurebastionhostsubnet" {
    name                 = "AzureBastionSubnet"
    resource_group_name  = azurerm_resource_group.playgroundgroup.name
    virtual_network_name = azurerm_virtual_network.playgroundnetwork.name
    address_prefixes       = ["10.10.2.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "bastionpublicip" {
    name                = "Bastion-PIP"
    location            = azurerm_resource_group.playgroundgroup.location
    resource_group_name = azurerm_resource_group.playgroundgroup.name
    allocation_method   = "Static"
    sku                 = "Standard"

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}

resource "azurerm_bastion_host" "playgroundbastionhost" {
  name                = "${var.resource_group}Bastion"
  location            = azurerm_resource_group.playgroundgroup.location
  resource_group_name = azurerm_resource_group.playgroundgroup.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.playgroundazurebastionhostsubnet.id
    public_ip_address_id = azurerm_public_ip.bastionpublicip.id
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "playgroundnsg" {
    name                = "${var.resource_group}-NSG"
    location            = var.location
    resource_group_name = azurerm_resource_group.playgroundgroup.name
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}
