//hub-spoke-azure/main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "HS-resources"
  location = "East US"
}

//HUB
resource "azurerm_virtual_network" "hub" {
  name                = "Hub-VNet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "hub_gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/27"]
}

/*
resource "azurerm_subnet" "hub_firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.2.0/26"]
}
*/

resource "azurerm_subnet" "hub_management_subnet" {
  name                 = "snet-management"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.3.0/24"]
}



//SPOKES

//spoke 1
resource "azurerm_virtual_network" "spoke1" {
  name                = "SPOKE1-VNet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "spoke1_snet_app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "spoke1_snet_data" {
  name                 = "snet-data"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = ["10.1.2.0/24"]
}



//spoke 2 
resource "azurerm_virtual_network" "spoke2" {
  name                = "SPOKE2-VNet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "spoke2_snet_app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke2.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_subnet" "spoke2_snet_data" {
  name                 = "snet-data"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke2.name
  address_prefixes     = ["10.2.2.0/24"]
}



//ON-PREM
resource "azurerm_virtual_network" "onprem" {
  name                = "onprem-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["192.168.0.0/16"]
}

resource "azurerm_subnet" "onprem_gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.onprem.name
  address_prefixes     = ["192.168.1.0/27"]
}

resource "azurerm_subnet" "onprem_snet_servers" {
  name                 = "snet-servers"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.onprem.name
  address_prefixes     = ["192.168.2.0/24"]
}


/*
//Routing table
resource "azurerm_route_table" "route_table" {
  name                = "route-table"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name                   = "UDR"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.2.4"
  }
}

//subnet_route_table_association
resource "azurerm_subnet_route_table_association" "spoke1_snet_app" {
  subnet_id      = azurerm_subnet.spoke1_snet_app.id
  route_table_id = azurerm_route_table.route_table.id
}
resource "azurerm_subnet_route_table_association" "spoke1_snet_data" {
  subnet_id      = azurerm_subnet.spoke1_snet_data.id
  route_table_id = azurerm_route_table.route_table.id
}
resource "azurerm_subnet_route_table_association" "spoke2_snet_app" {
  subnet_id      = azurerm_subnet.spoke2_snet_app.id
  route_table_id = azurerm_route_table.route_table.id
}
resource "azurerm_subnet_route_table_association" "spoke2_snet_data" {
  subnet_id      = azurerm_subnet.spoke2_snet_data.id
  route_table_id = azurerm_route_table.route_table.id
}
*/

module "gateway" {
  source = "./modules/gateway"

  resource_group_name      = azurerm_resource_group.rg.name
  resource_group_location  = azurerm_resource_group.rg.location
  hub_gateway_subnet_id    = azurerm_subnet.hub_gateway_subnet.id
  onprem_gateway_subnet_id = azurerm_subnet.onprem_gateway_subnet.id
}

module "peering" {
  source = "./modules/peering"

  resource_group_name = azurerm_resource_group.rg.name
  hub_vnet_name       = azurerm_virtual_network.hub.name
  hub_vnet_id         = azurerm_virtual_network.hub.id
  spoke1_vnet_name    = azurerm_virtual_network.spoke1.name
  spoke1_vnet_id      = azurerm_virtual_network.spoke1.id
  spoke2_vnet_name    = azurerm_virtual_network.spoke2.name
  spoke2_vnet_id      = azurerm_virtual_network.spoke2.id
}