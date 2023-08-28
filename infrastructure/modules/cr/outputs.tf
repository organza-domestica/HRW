output "cr_name" {
  value = azurerm_container_registry.cr.name
}

output "login_server" {
  value = azurerm_container_registry.cr.login_server
}

output "admin_username" {
  value = azurerm_container_registry.cr.admin_username
}

output "admin_password" {
  value = azurerm_container_registry.cr.admin_password
}
