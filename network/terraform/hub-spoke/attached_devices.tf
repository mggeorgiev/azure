# Hub
# Create Network Security Group and rule
resource "azurerm_network_security_group" "hubnsg" {
    name                            = "hubNSG"
    location                        = azurerm_virtual_network.vnetHub.location
    resource_group_name             = azurerm_resource_group.rghubspoke.name
    
    security_rule {
        name                        = "SSH"
        priority                    = 1001
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "22"
        source_address_prefix       = "*"
        destination_address_prefix  = "*"
    }

    tags = {
        environment                 = var.vnetHub["environment"],
        billing-code                = var.vnetHub["billing-code"]
    }
}

# Create network interface
resource "azurerm_network_interface" "hubNic" {
    name                             = "hubNic"
    location                         = azurerm_virtual_network.vnetHub.location
    resource_group_name              = azurerm_resource_group.rghubspoke.name

    ip_configuration {
        name                          = "hubNicConfiguration"
        subnet_id                     =  azurerm_subnet.hubSubnet.id
        private_ip_address_allocation = "Dynamic"
    }

    tags = {
        environment                 = var.vnetHub["environment"],
        billing-code                = var.vnetHub["billing-code"]
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.hubNic.id
    network_security_group_id = azurerm_network_security_group.hubnsg.id
}

#Spoke 1
# Create Network Security Group and rule
resource "azurerm_network_security_group" "spoke1nsg" {
    name                            = "spoke1NSG"
    location                        = azurerm_virtual_network.vnetSpoke1.location
    resource_group_name             = azurerm_resource_group.rghubspoke.name
    
    security_rule {
        name                        = "SSH"
        priority                    = 1001
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "22"
        source_address_prefix       = "*"
        destination_address_prefix  = "*"
    }

    tags = {
        environment                 = var.vnetHub["environment"],
        billing-code                = var.vnetHub["billing-code"]
    }
}

# Create network interface
resource "azurerm_network_interface" "spoke1Nic" {
    name                             = "spoke1Nic"
    location                         = azurerm_virtual_network.vnetSpoke1.location
    resource_group_name              = azurerm_resource_group.rghubspoke.name

    ip_configuration {
        name                          = "spoke1NicConfiguration"
        subnet_id                     =  azurerm_subnet.spoke1Subnet.id
        private_ip_address_allocation = "Dynamic"
    }

    tags = {
        environment                 = var.vnetHub["environment"],
        billing-code                = var.vnetHub["billing-code"]
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "spoke1nictonsg" {
    network_interface_id      = azurerm_network_interface.spoke1Nic.id
    network_security_group_id = azurerm_network_security_group.spoke1nsg.id
}

#Spoke 2
# Create Network Security Group and rule
resource "azurerm_network_security_group" "spoke2nsg" {
    name                            = "spoke2NSG"
    location                        = azurerm_virtual_network.vnetSpoke2.location
    resource_group_name             = azurerm_resource_group.rghubspoke.name
    
    security_rule {
        name                        = "SSH"
        priority                    = 1001
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "22"
        source_address_prefix       = "*"
        destination_address_prefix  = "*"
    }

    tags = {
        environment                 = var.vnetHub["environment"],
        billing-code                = var.vnetHub["billing-code"]
    }
}

# Create network interface
resource "azurerm_network_interface" "spoke2Nic" {
    name                             = "spoke2Nic"
    location                         = azurerm_virtual_network.vnetSpoke2.location
    resource_group_name              = azurerm_resource_group.rghubspoke.name

    ip_configuration {
        name                          = "spoke1NicConfiguration"
        subnet_id                     =  azurerm_subnet.spoke2Subnet.id
        private_ip_address_allocation = "Dynamic"
    }

    tags = {
        environment                 = var.vnetHub["environment"],
        billing-code                = var.vnetHub["billing-code"]
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "spoke2nictonsg" {
    network_interface_id      = azurerm_network_interface.spoke2Nic.id
    network_security_group_id = azurerm_network_security_group.spoke2nsg.id
}
