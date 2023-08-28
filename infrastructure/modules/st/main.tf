resource "azurerm_storage_account" "st" {
  name                      = var.name
  resource_group_name       = var.rg_name
  location                  = var.rg_location
  account_tier              = "Standard"
  account_replication_type  = var.replication_type
  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = true

  public_network_access_enabled   = var.enable_blob_private_endpoint ? false : true # Public means network access from the internet
  allow_nested_items_to_be_public = false                                           # Public means anonymous (without authentication) to the API. (aka. allowBlobPublicAccess)

  queue_encryption_key_type = "Account"
  table_encryption_key_type = "Account"

  identity {
    type = "UserAssigned"
    identity_ids = [
      var.cmk_encryption_umi_id
    ]
  }

  customer_managed_key {
    user_assigned_identity_id = var.cmk_encryption_umi_id
    key_vault_key_id          = var.cmk_encryption_key_id
  }
  
  blob_properties {
    versioning_enabled = true
    change_feed_enabled = true
    
    restore_policy {
      days = 30
    }

    delete_retention_policy {
      days = 35
    }

    container_delete_retention_policy {
      days = 30
    }
  }
  
}

resource "azurerm_monitor_diagnostic_setting" "st_logs" {
  name                       = "logs"
  target_resource_id         = "${azurerm_storage_account.st.id}/blobServices/default/"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"

    retention_policy {
      enabled = false
    }
  }
  enabled_log {
    category = "StorageWrite"

    retention_policy {
      enabled = false
    }
  }
  enabled_log {
    category = "StorageDelete"

    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "Capacity"

    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "Transaction"

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_storage_account_network_rules" "st_network_rules" {
  storage_account_id = azurerm_storage_account.st.id
  default_action     = "Deny"
}

resource "azurerm_private_endpoint" "blob_private_endpoint" {
  count = var.enable_blob_private_endpoint ? 1 : 0

  name                          = var.blob_private_endpoint_name
  resource_group_name           = var.rg_name
  location                      = var.rg_location
  subnet_id                     = var.private_endpoint_subnet_id
  custom_network_interface_name = var.blob_private_endpoint_nic_name

  private_service_connection {
    name                           = var.blob_private_endpoint_name
    private_connection_resource_id = azurerm_storage_account.st.id
    is_manual_connection           = false

    subresource_names = ["blob"]
  }

  ip_configuration {
    name               = "blob-ip-config"
    private_ip_address = var.blob_private_endpoint_ip_address
    subresource_name   = "blob"
    member_name        = "blob"
  }

}

