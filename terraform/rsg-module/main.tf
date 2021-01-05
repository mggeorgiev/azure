resource "azurerm_resource_group" "resourcegroup" {
    name                = var.rg_name
    location            = var.rg_location

    tags = {
        environment     = var.environementtag,
        billing-code    = var.billing-code
    }
}
