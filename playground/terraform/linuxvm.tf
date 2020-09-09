# Create public IPs
resource "azurerm_public_ip" "linuxpublicip" {
    name                                = "${var.vmnamelinux}VM-PIP"
    location                            = var.location
    resource_group_name                 = azurerm_resource_group.playgroundgroup.name
    allocation_method                   = "Dynamic"

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}

# Create network interface
resource "azurerm_network_interface" "linuxvmnic" {
    name                                = "${var.vmnamelinux}VM-NIC"
    location                            = var.location
    resource_group_name                 = azurerm_resource_group.playgroundgroup.name

    ip_configuration {
        name                            = "${var.vmnamelinux}NicConfiguration"
        subnet_id                       = azurerm_subnet.playgroundsubnet.id
        private_ip_address_allocation   = "Dynamic"
        public_ip_address_id            = azurerm_public_ip.linuxpublicip.id
    }

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id                = azurerm_network_interface.linuxvmnic.id
    network_security_group_id           = azurerm_network_security_group.playgroundnsg.id
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { value = "${tls_private_key.example_ssh.private_key_pem}" }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "playgroundlinuxvm" {
    name                                = var.vmnamelinux
    location                            = var.location
    resource_group_name                 = azurerm_resource_group.playgroundgroup.name
    network_interface_ids               = [azurerm_network_interface.linuxvmnic.id]
    size                                = "Standard_DS1_v2"
    #zone                                = var.zone

    os_disk {
        name                            = "${var.vmnamelinux}OsDisk"
        caching                         = "ReadWrite"
        storage_account_type            = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name                       = "${var.vmnamelinux}SandBox"
    admin_username                      = var.users[1]
    admin_password                      = var.admin_password
    disable_password_authentication     = false
        
    admin_ssh_key {
        username                        = var.users[1]
        public_key                      = tls_private_key.example_ssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri             = azurerm_storage_account.playgroundstorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}
