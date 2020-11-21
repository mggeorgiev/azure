# Create public IPs
resource "azurerm_public_ip" "linuxpublicip" {
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
resource "azurerm_network_interface" "linuxvmnic" {
    name                                = "${var.vmname}VM-NIC"
    location                            = var.location
    resource_group_name                 = var.resource_group

    ip_configuration {
        name                            = "${var.vmname}NicConfiguration"
        subnet_id                       = var.vnet_subnet_id
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
    network_security_group_id           = azurerm_network_security_group.linuxvmnsg.id
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { value = tls_private_key.example_ssh.private_key_pem }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "linuxvm" {
    name                                = var.vmname
    location                            = var.location
    resource_group_name                 = var.resource_group
    network_interface_ids               = [azurerm_network_interface.linuxvmnic.id]
    size                                = var.vmsize
#    zone                                = var.zones

    os_disk {
        name                            = "${var.vmname}OsDisk"
        caching                         = "ReadWrite"
        storage_account_type            = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name                       = var.vmname
    admin_username                      = var.users[1]
    admin_password                      = var.admin_password
    disable_password_authentication     = false
        
    admin_ssh_key {
        username                        = var.users[1]
        public_key                      = file(var.ssh_public_key) #tls_private_key.example_ssh.public_key_openssh
        #public_key                      = tls_private_key.example_ssh.public_key_openssh
    }

    custom_data                         = base64encode(file(var.cloud_init_file))  
    # boot_diagnostics {
    #     storage_account_uri             = azurerm_storage_account.playgroundstorageaccount.primary_blob_endpoint
    # }

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}

output vmmsize {
    value = azurerm_linux_virtual_machine.linuxvm.size
}

####

# Create Network Security Group and rule
resource "azurerm_network_security_group" "linuxvmnsg" {
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
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}
