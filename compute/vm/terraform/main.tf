variable "location" {
    default                     = "westeurope"
}

provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x.
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    features {}
}

resource "azurerm_resource_group" "mytestgroup" {
    name                        = "myTestGroup"
    location                    = var.location

    tags = {
        environment   = "Demo",
        billing-code  = "001"
    }
}

variable "vnetname" {
    default                     = "myTestVnet"
}

resource "azurerm_virtual_network" "mytestnetwork" {
    name                        = var.vnetname
    address_space               = ["10.11.0.0/16"]
    location                    = var.location
    resource_group_name         = azurerm_resource_group.mytestgroup.name

    tags = {
        environment   = "Demo",
        billing-code  = "001"
    }
}

variable subnetname {
    default = "mySubnet"
}
resource "azurerm_subnet" "mytestsubnet" {
    name                        = var.subnetname
    resource_group_name         = azurerm_resource_group.mytestgroup.name
    virtual_network_name        = azurerm_virtual_network.mytestnetwork.name
    address_prefixes            = ["10.11.2.0/24"]
}

}
resource "azurerm_subnet" "azurebastionhostsubnet" {
    name                            = "AzureBastionHost"
    resource_group_name             = azurerm_resource_group.mytestgroup.name
    virtual_network_name            = azurerm_virtual_network.mytestnetwork.name
    address_prefixes                = ["10.11.1.0/24"]
}

resource "azurerm_public_ip" "mytestmpublicip" {
    name                            = "myPublicIP"
    location                        = var.location
    resource_group_name             = azurerm_resource_group.mytestgroup.name
    allocation_method               = "Dynamic"

    tags = {
        environment   = "Demo",
        billing-code  = "001"
    }
}

resource "azurerm_network_security_group" "mytestmnsg" {
    name                            = "myNetworkSecurityGroup"
    location                        = var.location
    resource_group_name             = azurerm_resource_group.mytestgroup.name
    
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
        environment   = "Demo",
        billing-code  = "001"
    }
}

resource "azurerm_network_interface" "mytestmnic" {
    name                            = "myNIC"
    location                        = var.location
    resource_group_name             = azurerm_resource_group.mytestgroup.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.mytestmsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.mytestmpublicip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id            = azurerm_network_interface.mytestmnic.id
    network_security_group_id       = azurerm_network_security_group.mytestmnsg.id
}

resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group              = azurerm_resource_group.mytestgroup.name
    }
    
    byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
    name                            = "diag${random_id.randomId.hex}"
    resource_group_name             = azurerm_resource_group.mytestgroup.name
    location                        = var.location
    account_replication_type        = "LRS"
    account_tier                    = "Standard"

    tags = {
        environment   = "Demo",
        billing-code  = "001"
    }
}

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

output "tls_private_key" { value = "tls_private_key.example_ssh.private_key_pem" }

resource "azurerm_linux_virtual_machine" "mytestvm" {
    name                            = "myTestVM"
    location                        = azurerm_resource_group.mytestgroup.location
    resource_group_name             = azurerm_resource_group.mytestgroup.name
    network_interface_ids           = [azurerm_network_interface.mytestmnic.id]
    size                            = "Standard_DS1_v2"

    os_disk {
        name                        = "myOsDisk"
        caching                     = "ReadWrite"
        storage_account_type        = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    computer_name                   = "myvm"
    admin_username                  = "azureuser"
    disable_password_authentication = true
        
    admin_ssh_key {
        username                    = "azureuser"
        public_key                  = tls_private_key.example_ssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment   = "Demo",
        billing-code  = "001"
    }
}
