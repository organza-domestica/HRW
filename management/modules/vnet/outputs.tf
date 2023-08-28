#output "private_endpoints_subnet_id" {
#  value = azurerm_virtual_network.vnet.subnet.*.id[0]
#}
#
#output "cluster_subnet_id" {
#  value = azurerm_virtual_network.vnet.subnet.*.id[2]
#}

# output "app_service_integration_subnet_id" {
#   value = azurerm_virtual_network.vnet.subnet.*.id[4]
# }

output "vnet_id" {
   value = azurerm_virtual_network.vnet.id
 }
