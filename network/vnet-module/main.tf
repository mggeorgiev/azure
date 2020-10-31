# Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.resource_group}-vnet"
    address_space       = [var.address_space[0]]
    location            = var.location
    resource_group_name = var.resource_group

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}

# Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "${var.resource_group}-subnet"
    resource_group_name  = var.resource_group
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = [var.address_prefixes[0]]
}