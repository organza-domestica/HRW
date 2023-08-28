
resource "azurerm_log_analytics_workspace" "log" {
  name                = var.log_workspace_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku                 = "PerGB2018"
  daily_quota_gb      = var.daily_quota_gb
  retention_in_days   = var.log_analytics_retention_in_days
}

resource "azurerm_application_insights" "appi" {
  name                 = var.appi_name
  resource_group_name  = var.rg_name
  location             = var.rg_location
  workspace_id         = azurerm_log_analytics_workspace.log.id
  daily_data_cap_in_gb = var.daily_quota_gb
  application_type     = "web"
}
