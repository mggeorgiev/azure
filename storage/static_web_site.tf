resource "azurerm_resource_group" "martingeorgiev-staging-rg" {
    name                    = "martingeorgiev-staging-rg"
    location                = "westeurope"
}

resource "azurerm_storage_account" "martingeorgievdata001" {
  name                      = "martingeorgievdata001"
  resource_group_name       = azurerm_resource_group.martingeorgiev-staging-rg.name
  location                  = azurerm_resource_group.martingeorgiev-staging-rg.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
    
  static_website {
    index_document = "index.html"
  }

  tags = {
    environment             = "staging"
    billing-code            = "002"
 }
}

resource "azurerm_storage_container" "wwwroot" {
  name                  = "$web"
  storage_account_name  = azurerm_storage_account.martingeorgievdata001.name
  container_access_type = "container"
}
