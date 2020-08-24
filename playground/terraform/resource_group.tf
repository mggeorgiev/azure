resource "azurerm_resource_group" playgroundgroup {
    name     = var.resource_group
    location = var.location

    tags = {
        environment = var.environementtag,
        billing-code = var.billing-code
    }
}
