module "site_2_site_vpn_rsg" {
    source              = "git::https://github.com/mggeorgiev/azure.git//resource_group/terraform"
    rg_name             = var.resource_group_name
    rg_location         = var.resource_group_location
    environementtag     = "production"
    billing-code        = "100"
}

module "site_2_site_vpn_vnet" {
    source              = "git::https://github.com/mggeorgiev/azure.git//network/terraform/vnet-module"
    resource_group      = module.site_2_site_vpn_rsg.rg_name
    address_space       = var.address_space
    address_prefixes    = var.address_prefixes
    location            = module.site_2_site_vpn_rsg.rg_location
    environementtag     = "production"
    billing-code        = "100"
}

resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = module.site_2_site_vpn_rsg.rg_name
  virtual_network_name = module.site_2_site_vpn_vnet.vnet_name
  address_prefixes     = var.gw_address_prefixes
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
  address_space       = var.local_address_space
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