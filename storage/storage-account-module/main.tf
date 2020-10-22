# Create storage account to sync the state
resource "azurerm_storage_account" "storageaccount" {
    name                        = var.sto_name+"${random_id.randomId.hex}"
    resource_group_name         = var.resource_group
    location                    = var.sto_location
    account_tier                = var.tier #"Standard"
    account_replication_type    = var.replication_type #"LRS"

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

resource "azurerm_storage_share" "share" {
  name                 = "sharename"
  storage_account_name = azurerm_storage_account.storageaccount.name
  quota                = 50

  # acl {
  #   id = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"

  #   access_policy {
  #     permissions = "rwdl"
  #     start       = "2019-07-02T09:38:21.0000000Z"
  #     expiry      = "2019-07-02T10:38:21.0000000Z"
  #   }
  # }
}