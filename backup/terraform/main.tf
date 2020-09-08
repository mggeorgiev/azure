resource "azurerm_recovery_services_vault" "rsvault" {
  name                = var.rsvault
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "Standard"

  soft_delete_enabled = true

  tags = {
        reviewbefore = formatdate("YYYY-MMM-DD",timeadd(timestamp(), "9m")),
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}
