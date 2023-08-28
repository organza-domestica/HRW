output "private_endpoints_subnet_id" {
  value = azurerm_virtual_network.vnet.subnet.*.id[0]
}

output "cluster_subnet_id" {
  value = azurerm_virtual_network.vnet.subnet.*.id[1]
}
