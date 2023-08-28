resource "azurerm_mssql_server" "sql_server" {
  name                              = var.sql_server_name
  resource_group_name               = var.rg_name
  location                          = var.rg_location
  version                           = "12.0"
  administrator_login               = var.sql_administrator_login
  administrator_login_password      = var.sql_administrator_password
  minimum_tls_version               = "1.2"
  public_network_access_enabled     = var.enable_private_endpoint ? false : true
  primary_user_assigned_identity_id = var.tde_cmk_encryption_umi_id

  identity {
    type = "UserAssigned"
    identity_ids = [
      var.tde_cmk_encryption_umi_id
    ]
  }
  
  azuread_administrator {
    login_username = var.sql_azuread_administrator_login
    object_id      = var.sql_azuread_administrator_id
  }
}

resource "azurerm_mssql_server_transparent_data_encryption" "tde_encryption" {
  server_id             = azurerm_mssql_server.sql_server.id
  key_vault_key_id      = var.tde_cmk_encryption_key_id
  auto_rotation_enabled = true
}

resource "azurerm_role_assignment" "audit_blob_data_contributor" {
  scope                = var.auditing_storage_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.tde_cmk_encryption_umi_principal_id
}

resource "azurerm_mssql_server_extended_auditing_policy" "auditing_policy" {
  server_id         = azurerm_mssql_server.sql_server.id
  storage_endpoint  = var.auditing_storage_blob_endpoint
  retention_in_days = var.sql_server_auditing_storage_retention_in_days

  depends_on = [
    azurerm_role_assignment.audit_blob_data_contributor
  ]
}

resource "azurerm_mssql_database" "db" {
  name        = var.sql_db_name
  server_id   = azurerm_mssql_server.sql_server.id
  sku_name    = var.sql_db_sku_name
  max_size_gb = var.sql_db_max_size_gb
  collation   = "Polish_CI_AS"

  depends_on = [
    azurerm_mssql_firewall_rule.mssql_firewall,
    azurerm_private_endpoint.sql_private_endpoint
  ]

  short_term_retention_policy {
    retention_days = var.sql_db_short_term_retention_in_days
  }
}

resource "azurerm_mssql_firewall_rule" "mssql_firewall" {
  count = var.enable_private_endpoint ? 0 : 1

  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_private_endpoint" "sql_private_endpoint" {
  count = var.enable_private_endpoint ? 1 : 0

  name                          = var.private_endpoint_name
  resource_group_name           = var.rg_name
  location                      = var.rg_location
  subnet_id                     = var.private_endpoint_subnet_id
  custom_network_interface_name = var.private_endpoint_nic_name

  private_service_connection {
    name                           = var.private_endpoint_name
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    is_manual_connection           = false

    subresource_names = ["sqlServer"]
  }

  ip_configuration {
    name               = "sqlServer-ip-config"
    private_ip_address = var.private_endpoint_ip_address
    subresource_name   = "sqlServer"
    member_name        = "sqlServer"
  }
}

