resource "azurerm_resource_group" "private-acr" {
    name                    = "private-acr"
    location                = "westeurope"
}

resource "azurerm_container_registry" "acrprivate" {
  name                     = "acrprivate"
  resource_group_name      = azurerm_resource_group.private-acr.name
  location                 = azurerm_resource_group.private-acr.location
  sku                      = "Basic"
  admin_enabled            = true
  #georeplication_locations = ["West Europe"]
}
