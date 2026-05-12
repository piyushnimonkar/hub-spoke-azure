//Spoke1
resource "azurerm_virtual_network_peering" "spoke1_peering1" {
  name                      = "spoke1peer1"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = var.spoke1_vnet_id
  allow_gateway_transit = true
}

resource "azurerm_virtual_network_peering" "spoke1_peering2" {
  name                      = "spoke1peer2"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.spoke1_vnet_name
  remote_virtual_network_id = var.hub_vnet_id
  use_remote_gateways = true
  depends_on          = [module.gateway]
}

//Spoke2
resource "azurerm_virtual_network_peering" "spoke2_peering1" {
  name                      = "spoke2peer1"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = var.spoke2_vnet_id
  allow_gateway_transit = true
}

resource "azurerm_virtual_network_peering" "spoke2_peering2" {
  name                      = "spoke2peer2"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.spoke2_vnet_name
  remote_virtual_network_id = var.hub_vnet_id
  use_remote_gateways = true
  depends_on          = [module.gateway]
}