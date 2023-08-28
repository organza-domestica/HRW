variable "environment" {
  type = string
}

variable "sql_administrator_login" {
  type      = string
  sensitive = true
}

variable "sql_azuread_administrator_id" {
  type = string
}

variable "sql_azuread_administrator_login" {
  type = string
}

variable "sql_db_sku_name" {
  type    = string
  default = "Basic"
}

variable "sql_db_max_size_gb" {
  type    = number
  default = 2
}

variable "sql_db_short_term_retention_in_days" {
  type    = number
  default = 7
}

variable "sql_server_storage_auditing_retention_in_days" {
  type    = number
  default = 90
}

variable "container_registry_sku" {
  type    = string
  default = "Basic"
}

variable "storage_replication_type" {
  type    = string
  default = "LRS"
}

variable "log_analytics_daily_quota_gb" {
  type    = number
  default = 0.5
}

variable "log_analytics_retention_in_days" {
  type    = number
  default = 30
}

variable "k8s_argocd_app_of_apps_repo_key" {
  type      = string
  sensitive = true
  default   = ""
}

variable "azure_kv_sp_secret" {
  type    = string
  default = ""
}

variable "azure_acr_helm_username" {
  type    = string
  default = ""
}

variable "azure_acr_helm_password" {
  type      = string
  sensitive = true
  default   = ""
}

variable "externalapi_hrwservice" {
  type    = string
  default = "https://hrwservice-be-azure.dv11-be.tl.pl/HRW/Service/api/"
}

variable "azuread_client_id" {
  type    = string
  default = "f84e930b-849a-4861-bec0-c20be5e79edc"
}

variable "azuread_redirect_uri" {
  type    = string
  default = "https://lm-web-hrw-dev.azurewebsites.net/login"
}

variable "app_hrw_url" {
  type    = string
  default = "https://lm-web-hrw-dev.azurewebsites.net"
}

variable "aks_private_cluster_enabled" {
  type    = bool
  default = false
}

variable "enable_storage_blob_private_endpoint" {
  type    = bool
  default = true
}

variable "storage_blob_private_endpoint_ip_address" {
  type    = string
  default = "10.172.16.4"
}

variable "enable_sql_private_endpoint" {
  type    = bool
  default = true
}

variable "sql_private_endpoint_ip_address" {
  type    = string
  default = "10.172.16.5"
}

variable "enable_vault_private_endpoint" {
  type    = bool
  default = false
}

variable "vault_private_endpoint_ip_address" {
  type    = string
  default = "10.172.16.6"
}

variable "vnet_address_prefix" {
  type    = string
  default = "10.172.16.0/24"
}

variable "vnet_dns_servers" {
  type    = list(string)
  default = ["10.172.255.4"]
}

variable "private_endpoints_subnet_address_prefix" {
  type    = string
  default = "10.172.16.0/27"
}

variable "application_gateway_subnet_address_prefix" {
  type    = string
  default = "10.172.16.32/28"
}

variable "cluster_subnet_address_prefix" {
  type    = string
  default = "10.172.16.48/28"
}

variable "cluster_ingress_subnet_address_prefix" {
  type    = string
  default = "10.172.16.64/29"
}

variable "aks_admin_group_object_id" {
  type    = string
  default = ""
}

variable "service_principal_secret" {
  type    = string
  default = ""
}
