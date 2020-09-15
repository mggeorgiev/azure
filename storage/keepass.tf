
variable location {
    type    = string
    default = "eastus"
}

variable resource_group {
    type    = string
    default = "rg-keepas-01"
}

variable environementtag {
    type    = string
    default = "production"
}

variable billing-code {
    type    = string
    default = "001"
}

#Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.keepassgroup.name
    }
    
    byte_length = 8
}

resource "azurerm_resource_group" "keepassgroup" {
    name     = var.resource_group
    location = var.location
    #subscription_id = var.subscriptionID

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}

# Create storage account to sync the state
resource "azurerm_storage_account" "keepasstorageaccount" {
    name                        = "keepass${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.keepassgroup.name
    location                    = var.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}

resource "azurerm_storage_container" "sync" {
  name                  = "sync"
  storage_account_name  = azurerm_storage_account.keepasstorageaccount.name
  container_access_type = "private"
}
