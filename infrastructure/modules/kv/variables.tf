variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "name" {
  type = string
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

variable "id_name" {
  type = string
}

variable "id_sql_server_name" {
  type = string
}

variable "id_storage_name" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

# variable "web_app_name" {
#   type = string
# }

# variable "cr_name" {
#   type = string
# }

# variable "appi_name" {
#   type = string
# }

# variable "redis_name" {
#   type = string
# }

# variable "storage_name" {
#   type = string
# }

# variable "sql_server_name" {
#   type = string
# }

# variable "sql_db_name" {
#   type = string
# }

# variable "sql_db_password" {
#   type      = string
#   sensitive = true
# }

# variable "kv_secret_name_appi_key" {
#   type = string
# }

# variable "kv_secret_name_appi_connection_string" {
#   type = string
# }

# variable "kv_secret_name_docker_registry_server_url" {
#   type = string
# }

# variable "kv_secret_name_docker_registry_server_username" {
#   type = string
# }

# variable "kv_secret_name_docker_registry_server_password" {
#   type = string
# }

variable "kv_secret_name_sql_server_admin_password" {
  type = string
}

# variable "kv_secret_name_redis_connection_string" {
#   type = string
# }

# variable "kv_secret_name_hrw_database_connection_string" {
#   type = string
# }

# variable "kv_secret_name_hangfire_database_connection_string" {
#   type = string
# }

# variable "kv_secret_name_azure_blob_storage_connection_string" {
#   type = string
# }
