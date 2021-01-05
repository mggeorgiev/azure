module "site_2_site_vpn_rsg" {
    source              = "./../azure/terraform/rsg-module"
    rg_name             = "site-to-site-vpn"
    rg_location         = "westeurope"
    environementtag     = "production"
    billing-code        = "100"
}

module "site_2_site_vpn_vnet" {
    source              = "./../azure/terraform/vnet-module"
    resource_group      = module.site_2_site_vpn_rsg.rg_name
    address_space       = ["10.4.0.0/16"]
    address_prefixes    = ["10.4.0.0/24"]
    location            = module.site_2_site_vpn_rsg.rg_location
    environementtag     = "production"
    billing-code        = "100"
}

resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = module.site_2_site_vpn_rsg.rg_name
  virtual_network_name = module.site_2_site_vpn_vnet.vnet_name
  address_prefixes     = ["10.4.255.0/27"]

#   delegation {
#     name = "delegation"

#     service_delegation {
#       name    = "Microsoft.ContainerInstance/containerGroups"
#       actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
#     }
#   }
  }