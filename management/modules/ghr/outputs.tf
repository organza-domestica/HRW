output "resource_group_name" {
  value = local.rg_name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.vm_gh_runner.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.auto_ssh.private_key_pem
  sensitive = true
}

