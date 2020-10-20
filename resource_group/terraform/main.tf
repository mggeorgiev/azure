resource "azurerm_resource_group" resourcegroup {
    name                = var.rg_name
    location            = var.rg_location
    subscription_id     = var.subscriptionID

    tags = {
        environment     = var.environementtag,
        billing-code    = var.billing-code
    }
}
