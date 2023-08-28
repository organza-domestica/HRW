environment = "prod"

sql_db_sku_name                     = "S4"
sql_db_max_size_gb                  = 250
sql_db_short_term_retention_in_days = 35
sql_azuread_administrator_login = "DBS_AZ_PROD_RW_hrw_az-lx-sql-hrw-prod"
sql_azuread_administrator_id = "bc13940c-aa61-4753-87e9-14a658983d01"
# sql_server_storage_auditing_retention_in_days = 30
container_registry_sku          = "Basic"
storage_replication_type        = "ZRS"
log_analytics_daily_quota_gb    = 5
log_analytics_retention_in_days = 90
aks_admin_group_object_id       = "1e4ed61e-4c3e-4668-b5ea-e6adb09a2d6b"

# Networking
vnet_address_prefix                       = "10.172.11.0/24"
vnet_dns_servers                          = ["10.172.255.4"]
private_endpoints_subnet_address_prefix   = "10.172.11.0/27"
application_gateway_subnet_address_prefix = "10.172.11.32/28"
cluster_subnet_address_prefix             = "10.172.11.48/28"
cluster_ingress_subnet_address_prefix     = "10.172.11.64/29"

# Private resources
aks_private_cluster_enabled              = true
enable_storage_blob_private_endpoint     = true
storage_blob_private_endpoint_ip_address = "10.172.11.4"
enable_sql_private_endpoint              = true
sql_private_endpoint_ip_address          = "10.172.11.5"
enable_vault_private_endpoint            = true
vault_private_endpoint_ip_address        = "10.172.11.6"
