# Create storage account to sync the state
resource "azurerm_storage_account" "storageaccount" {
    name                        = var.sto_name+"${random_id.randomId.hex}"
    resource_group_name         = var.resource_group
    location                    = var.sto_location
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