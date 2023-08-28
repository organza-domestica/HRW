

resource "azurerm_container_registry" "cr" {
  name                = var.name
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku                 = var.sku
  admin_enabled       = true
}

resource "azurerm_monitor_diagnostic_setting" "cr_logs" {
  name                       = "logs"
  target_resource_id         = azurerm_container_registry.cr.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ContainerRegistryLoginEvents"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "ContainerRegistryRepositoryEvents"

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
