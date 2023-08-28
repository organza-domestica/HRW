output "appi_name" {
  value = azurerm_application_insights.appi.name
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.log.id
}