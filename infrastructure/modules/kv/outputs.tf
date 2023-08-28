output "id" {
  value = azurerm_key_vault.kv.id
}

output "uri" {
  value = azurerm_key_vault.kv.vault_uri
}

output "sql_administrator_password" {
  value = random_password.sql_server.result
}

output "data_encryption_key_id" {
  value = azurerm_key_vault_key.data_encryption_key.id
}

output "data_encryption_key_versionless_id" {
  value = azurerm_key_vault_key.data_encryption_key.versionless_id
}

output "storage_identity_id" {
  value = azurerm_user_assigned_identity.storage_identity.id
}

output "sql_server_identity_id" {
  value = azurerm_user_assigned_identity.sql_server_identity.id
}

output "sql_server_identity_principal_id" {
  value = azurerm_user_assigned_identity.sql_server_identity.principal_id
}

output "umi_client_id" {
  value = azurerm_user_assigned_identity.id.client_id
}

output "umi_id" {
  value = azurerm_user_assigned_identity.id.id
}
