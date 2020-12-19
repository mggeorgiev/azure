# Create public IPs
resource "azurerm_public_ip" "windowspublicip" {
    name                                = "${var.vmname}VM-PIP"
    location                            = var.location
    resource_group_name                 = var.resource_group
    allocation_method                   = "Dynamic"

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}

# Create network interface
resource "azurerm_network_interface" "windowsvmnic" {
    name                                = "${var.vmname}VM-NIC"
    location                            = var.location
    resource_group_name                 = var.resource_group

    ip_configuration {
        name                            = "${var.vmname}NicConfiguration"
        subnet_id                       = var.vnet_subnet_id
        private_ip_address_allocation   = "Dynamic"
        public_ip_address_id            = azurerm_public_ip.windowspublicip.id
    }

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id                = azurerm_network_interface.windowsvmnic.id
    network_security_group_id           = azurerm_network_security_group.windowsvmnsg.id
}


# Create virtual machine
resource "azurerm_windows_virtual_machine" "windowsvm" {    
    name                            = var.vmname
    location                        = var.location
    resource_group_name             = var.resource_group
    network_interface_ids           = [azurerm_network_interface.windowsvmnic.id]
    size                            = "Standard_DS1_v2"
    #zone                                = var.zone

    os_disk {
        name                        = "${var.vmname}OsDisk"
        caching                     = "ReadWrite"
        storage_account_type        = "Premium_LRS"
    }

    source_image_reference {
        publisher                   = "MicrosoftWindowsServer"
        offer                       = "WindowsServer"
        sku                         = "2016-Datacenter"
        version                     = "latest"
    }

    computer_name                   = "${var.vmname}SandBox"
    admin_username                  = var.users[1]
    admin_password                  = var.admin_password

    # boot_diagnostics {
    #     storage_account_uri         = azurerm_storage_account.playgroundstorageaccount.primary_blob_endpoint
    # }

    tags = {
        environment                 = var.environementtag,
        billing-code                = var.billing-code
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "windowsvmnsg" {
    name                = "${var.vmname}-NSG"
    location            = var.location
    resource_group_name = var.resource_group
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}

