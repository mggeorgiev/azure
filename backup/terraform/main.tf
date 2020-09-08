resource "azurerm_recovery_services_vault" "rsvault" {
  name                = var.rsvault
  location            = var.location
  resource_group_name = azurerm_resource_group.rgoadglobal.name
  sku                 = "Standard"

  soft_delete_enabled = true

  tags = {
        reviewbefore = formatdate("YYYY-MMM-DD",timeadd(timestamp(), "9m"))
    }
}
