# Configure the Microsoft Azure Provider
#provider "azurerm" {
#    # The "feature" block is required for AzureRM provider 2.x. 
#    # If you're using version 1.x, the "features" block is not allowed.
#    version = "~>2.0"
#    features {}
#}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "myplaygroundgroup" {
    name     = "playground"
    location = "eastus"

    tags = {
        environment = "playground",
        billing-code = 010
    }
}

# Create virtual network
resource "azurerm_virtual_network" "myplaygroundnetwork" {
    name                = "playground-vnet"
    address_space       = ["10.10.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.myplaygroundgroup.name

    tags = {
        environment = "playground",
        billing-code = 010
    }
}

# Create subnet
resource "azurerm_subnet" "myplaygroundsubnet" {
    name                 = "playground-subnet"
    resource_group_name  = azurerm_resource_group.myplaygroundgroup.name
    virtual_network_name = azurerm_virtual_network.myplaygroundgroup.name
    address_prefixes       = ["10.10.1.0/24"]
}

# Create subnet for AzureBastionHost
resource "azurerm_subnet" "myplaygroundazurebastionhostsubnet" {
    name                 = "AzureBastionHost"
    resource_group_name  = azurerm_resource_group.myplaygroundgroup.name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefixes       = ["10.10.2.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "mylinuxpublicip" {
    name                         = "myLinuxVM-PIP"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.myplaygroundgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "playground",
        billing-code = 010
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myplaygroundnsg" {
    name                = "playground-NSG"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.myplaygroundgroup.name
    
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
        environment = "playground",
        billing-code = 010
    }
}

# Create network interface
resource "azurerm_network_interface" "mylinuxvmnic" {
    name                      = "linuxVM-NIC"
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.myplaygroundgroup.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }

    tags = {
        environment = "playground",
        billing-code = 010
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.myterraformnic.id
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.myplaygroundgroup.name
    }
    
    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.myplaygroundgroup.name
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "plyground",
        billing-code = 010
    }
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { value = "${tls_private_key.example_ssh.private_key_pem}" }

# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm" {
    name                  = "myVM"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.myplaygroundgroup.name
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "ubuntuSandBox"
    admin_username = "azureuser"
    disable_password_authentication = true
        
    admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.example_ssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "plyground",
        billing-code = 010
    }
}