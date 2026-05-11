//Spoke1
resource "azurerm_virtual_network_peering" "spoke1_peering1" {
  name                      = "spoke1peer1"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke1.id
  allow_gateway_transit = true
}

resource "azurerm_virtual_network_peering" "spoke1_peering2" {
  name                      = "spoke1peer2"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.spoke1.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  use_remote_gateways = true
}

//Spoke2
resource "azurerm_virtual_network_peering" "spoke2_peering1" {
  name                      = "spoke2peer1"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke2.id
  allow_gateway_transit = true
}

resource "azurerm_virtual_network_peering" "spoke2_peering2" {
  name                      = "spoke2peer2"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.spoke2.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  use_remote_gateways = true
}