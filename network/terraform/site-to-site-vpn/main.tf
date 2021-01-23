module "site_2_site_vpn_rsg" {
    source              = "./../../../../azure/terraform/rsg-module"
    rg_name             = "site-to-site-vpn"
    rg_location         = "westeurope"
    environementtag     = "production"
    billing-code        = "100"
}

module "site_2_site_vpn_vnet" {
    source              = "./../../../../azure/terraform/vnet-module"
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

resource "azurerm_public_ip" "site2sitevpnpip" {
  name                = "site2sitevpnpip"
  location            = module.site_2_site_vpn_rsg.rg_location
  resource_group_name = module.site_2_site_vpn_rsg.rg_name

  allocation_method = "Dynamic"
}


resource "azurerm_local_network_gateway" "onpremise" {
  name                = var.local_gateway_name
  resource_group_name = module.site_2_site_vpn_rsg.rg_name
  location            = module.site_2_site_vpn_rsg.rg_location
  gateway_address     = var.onprempip
  address_space       = ["192.168.88.0/24", "192.168.8.0/24"]
}

resource "azurerm_virtual_network_gateway" "site2sitevpngw" {
  name                = var.gateway_name
  location            = module.site_2_site_vpn_rsg.rg_location
  resource_group_name = module.site_2_site_vpn_rsg.rg_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = var.gw_sku

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.site2sitevpnpip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.GatewaySubnet.id
  }
}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  name                = var.connection_name
  location            = module.site_2_site_vpn_rsg.rg_location
  resource_group_name = module.site_2_site_vpn_rsg.rg_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.site2sitevpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.onpremise.id

  shared_key = var.shared_key
}