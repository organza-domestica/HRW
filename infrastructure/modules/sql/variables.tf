variable "log_analytics_workspace_id" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "sql_server_name" {
  type = string
}

variable "sql_db_name" {
  type = string
}

variable "sql_azuread_administrator_id" {
  type = string
}

variable "sql_azuread_administrator_login" {
  type = string
}

variable "sql_administrator_login" {
  type = string
}

variable "sql_administrator_password" {
  type      = string
  sensitive = true
}

variable "sql_server_auditing_storage_retention_in_days" {
  type = number
}

variable "sql_db_sku_name" {
  type = string
}

variable "sql_db_max_size_gb" {
  type = number
}

variable "sql_db_short_term_retention_in_days" {
  type = number
}

variable "enable_private_endpoint" {
  type = bool
}

variable "private_endpoint_subnet_id" {
  type = string
}

variable "private_endpoint_name" {
  type = string
}

variable "private_endpoint_nic_name" {
  type = string
}

variable "private_endpoint_ip_address" {
  type = string
}

variable "tde_cmk_encryption_umi_id" {
  type = string
}

variable "tde_cmk_encryption_umi_principal_id" {
  type = string
}

variable "tde_cmk_encryption_key_id" {
  type = string
}

variable "auditing_storage_id" {
  type = string
}

variable "auditing_storage_blob_endpoint" {
  type = string
}
