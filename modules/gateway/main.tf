//Hub
resource "azurerm_public_ip" "hub_gw_pip" {
  name                = "hub-gw-pip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_virtual_network_gateway" "hub_gw" {
  name                = "hub-gw"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.hub_gw_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.hub_gateway_subnet_id
  }

  bgp_settings {
    asn = 65515  # hub
  }
}

//Onprem
resource "azurerm_public_ip" "onprem_gw_pip" {
  name                = "onprem-gw-pip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_virtual_network_gateway" "onprem_gw" {
  name                = "onprem-gw"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.onprem_gw_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.onprem_gateway_subnet_id
  }

  bgp_settings {
    asn = 65001  # onprem
  }
}

//Point 5 - VPN Connection (S2S tunnel)

resource "azurerm_local_network_gateway" "onprem" {
  name                = "onprem"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  gateway_address     = azurerm_public_ip.onprem_gw_pip.ip_address
  address_space       = ["192.168.0.0/16"]
}

resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  name                = "onpremise"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.hub_gw.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem.id

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}