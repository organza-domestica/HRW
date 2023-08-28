
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = [var.address_prefix]
  dns_servers         = var.dns_servers

  subnet {
    name           = "az-lx-snet-privateendpoints-hrw-${var.environment}"
    address_prefix = var.private_endpoints_subnet_address_prefix
  }

  subnet {
    name           = "az-lx-snet-cluster-hrw-${var.environment}"
    address_prefix = var.cluster_subnet_address_prefix
  }

  subnet {
    name           = "az-lx-snet-ingress-hrw-${var.environment}"
    address_prefix = var.cluster_ingress_subnet_address_prefix
  }
}

resource "azurerm_route_table" "rt_hub_firewall" {
  name                          = "az-lx-rt-hrw-${var.environment}"
  location                      = var.rg_location
  resource_group_name           = var.rg_name
  disable_bgp_route_propagation = false

  route {
    name           = "az-lx-hrw-to-hub-${var.environment}"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.172.255.52"
  }
}

resource "azurerm_subnet_route_table_association" "snet_cluster_rt_hub_firewall_association" {
  subnet_id      = azurerm_virtual_network.vnet.subnet.*.id[1]
  route_table_id = azurerm_route_table.rt_hub_firewall.id
}

# resource "azurerm_virtual_network_peering" "vnet_peering_hrw_dev_hub_001" {
#   name                         = "az-lx-peer-hrw-dev-hub"
#   resource_group_name          = var.rg_name
#   virtual_network_name         = azurerm_virtual_network.vnet.name
#   remote_virtual_network_id    = var.hub_remote_virtual_network_id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = true
# }
