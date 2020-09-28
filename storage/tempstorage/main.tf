
variable location {
    type    = string
    default = "eastus"
}

variable resource_group {
    type    = string
    default = "rg-tempstorage-01"
}

variable storage_account_name {
    type    = string
    default = "stotemp"
}


variable environementtag {
    type    = string
    default = "test"
}

variable billing-code {
    type    = string
    default = "001"
}

#Generate random text for a unique storage account name
resource "random_id" "storandomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.tempstorage.name
    }
    
    byte_length = 8
}

resource "azurerm_resource_group" "tempstorage" {
    name     = var.resource_group
    location = var.location
    #subscription_id = var.subscriptionID

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}

# Create storage account to sync the state
resource "azurerm_storage_account" "tempstorageaccount" {
    name                        = "${var.storage_account_name}${random_id.storandomId.hex}"
    resource_group_name         = azurerm_resource_group.tempstorage.name
    location                    = var.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"
    allow_blob_public_access    = true

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}

resource "azurerm_storage_container" "tempcont" {
  name                  = "tempcont"
  storage_account_name  = azurerm_storage_account.tempstorageaccount.name
  container_access_type = "container"
}
