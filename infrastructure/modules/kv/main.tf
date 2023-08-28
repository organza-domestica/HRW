data "azurerm_client_config" "current" {}

resource "random_password" "sql_server" {
  length  = 16
  special = true
}

resource "azurerm_user_assigned_identity" "id" {
  name                = var.id_name
  resource_group_name = var.rg_name
  location            = var.rg_location
}

resource "azurerm_user_assigned_identity" "sql_server_identity" {
  name                = var.id_sql_server_name
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_user_assigned_identity" "storage_identity" {
  name                = var.id_storage_name
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_key_vault" "kv" {
  name                          = var.name
  resource_group_name           = var.rg_name
  location                      = var.rg_location
  enabled_for_disk_encryption   = true
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = true
  sku_name                      = "standard"
  enable_rbac_authorization     = true
  public_network_access_enabled = var.enable_private_endpoint ? false : true
}

resource "azurerm_monitor_diagnostic_setting" "kv_logs" {
  name                           = "logs"
  target_resource_id             = azurerm_key_vault.kv.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "AzureDiagnostics"

  enabled_log {
    category = "AuditEvent"

    retention_policy {
      enabled = false
    }
  }
  enabled_log {
    category = "AzurePolicyEvaluationDetails"

    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}

# https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli#azure-built-in-roles-for-key-vault-data-plane-operations
resource "azurerm_role_assignment" "current_principal_key_vault_administrator" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "aks_identity_key_vault_secrets_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.id.principal_id
}

resource "azurerm_role_assignment" "sql_server_identity_key_vault_crypto_service_encryption_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.sql_server_identity.principal_id
}

resource "azurerm_role_assignment" "storage_identity_key_vault_crypto_service_encryption_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.storage_identity.principal_id
}

resource "azurerm_private_endpoint" "vault_private_endpoint" {
  count = var.enable_private_endpoint ? 1 : 0

  name                          = var.private_endpoint_name
  resource_group_name           = var.rg_name
  location                      = var.rg_location
  subnet_id                     = var.private_endpoint_subnet_id
  custom_network_interface_name = var.private_endpoint_nic_name

  private_service_connection {
    name                           = var.private_endpoint_name
    private_connection_resource_id = azurerm_key_vault.kv.id
    is_manual_connection           = false

    subresource_names = ["vault"]
  }

  ip_configuration {
    name               = "vault-ip-config"
    private_ip_address = var.private_endpoint_ip_address
    subresource_name   = "vault"
    member_name        = "default"
  }
}

resource "azurerm_key_vault_key" "data_encryption_key" {
  name         = "dataEncryptionKey"
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = ["decrypt", "encrypt", "sign", "unwrapKey", "wrapKey", "verify"]

  depends_on = [
    azurerm_role_assignment.current_principal_key_vault_administrator
  ]
}

resource "azurerm_key_vault_secret" "sql_server_admin_password" {
  name            = var.kv_secret_name_sql_server_admin_password
  value           = random_password.sql_server.result
  key_vault_id    = azurerm_key_vault.kv.id
  content_type    = "password"
  expiration_date = "2030-12-31T00:00:00Z"

  depends_on = [
    azurerm_role_assignment.current_principal_key_vault_administrator
  ]
}
