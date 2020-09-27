resource "azurerm_storage_account" "stomssql" {
  name                                    = "stomssql"
  resource_group_name                     = var.resource_group
  location                                = var.location
  account_tier                            = "Standard"
  account_replication_type                = "LRS"
}

resource "azurerm_sql_server" "mssqlserver" {
  name                                    = "mssqlserverdemo"
  resource_group_name                     = var.resource_group
  location                                = var.location
  version                                 = "12.0"
  administrator_login                     = "sqluser"
  administrator_login_password            = "KBUBXF68vIAJVgBmpR2P"

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.stomssql.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.stomssql.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }

  tags = {
    environment   = "test",
    billing-code  = "010"
  }
}
