# Create public IPs
resource "azurerm_public_ip" "windowspublicip" {
    name                            = "${var.vmnamewindows}VM-PIP"
    location                        = var.location
    resource_group_name             = azurerm_resource_group.playgroundgroup.name
    allocation_method               = "Dynamic"

    tags = {
        environment                 = var.environementtag,
        billing-code                = var.billing-code
    }
}

# Create network interface
resource "azurerm_network_interface" "windowsvmnic" {
    name                             = "${var.vmnamewindows}VM-NIC"
    location                         = var.location
    resource_group_name              = azurerm_resource_group.playgroundgroup.name

    ip_configuration {
        name                          = "${var.vmnamewindows}NicConfiguration"
        subnet_id                     = azurerm_subnet.playgroundsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.windowspublicip.id
    }

    tags = {
        environment                   = var.environementtag,
        billing-code                  = var.billing-code
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "windowswm" {
    network_interface_id             = azurerm_network_interface.windowsvmnic.id
    network_security_group_id        = azurerm_network_security_group.playgroundnsg.id
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "playgroundwindowsvm" {    
    name                            = var.vmnamewindows
    location                        = var.location
    resource_group_name             = azurerm_resource_group.playgroundgroup.name
    network_interface_ids           = [azurerm_network_interface.windowsvmnic.id]
    size                            = "Standard_DS1_v2"
    #zone                                = var.zone

    os_disk {
        name                        = "${var.vmnamewindows}OsDisk"
        caching                     = "ReadWrite"
        storage_account_type        = "Premium_LRS"
    }

    source_image_reference {
        publisher                   = "MicrosoftWindowsServer"
        offer                       = "WindowsServer"
        sku                         = "2016-Datacenter"
        version                     = "latest"
    }

    computer_name                   = "${var.vmnamewindows}SandBox"
    admin_username                  = var.users[1]
    admin_password                  = var.admin_password

    boot_diagnostics {
        storage_account_uri         = azurerm_storage_account.playgroundstorageaccount.primary_blob_endpoint
    }

    tags = {
        environment                 = var.environementtag,
        billing-code                = var.billing-code
    }
}
