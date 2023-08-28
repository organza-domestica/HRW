environment = "marian"

sql_db_sku_name                     = "Basic"
sql_db_max_size_gb                  = 2
sql_db_short_term_retention_in_days = 7
sql_azuread_administrator_login = "DBS_AZ_DEVTEST_RW_hrw_az-lx-sql-hrw-devtest"
sql_azuread_administrator_id = "da5ff032-663f-4286-8928-38dca0173de0"
# sql_server_storage_auditing_retention_in_days = 30
container_registry_sku          = "Basic"
storage_replication_type        = "LRS"
log_analytics_daily_quota_gb    = 0.5
log_analytics_retention_in_days = 30
aks_admin_group_object_id       = "9d1d27c7-453c-4925-8556-5385b139d701"

# Networking
vnet_address_prefix                       = "10.172.16.0/24"
vnet_dns_servers                          = ["10.172.255.4"]
private_endpoints_subnet_address_prefix   = "10.172.16.0/27"
application_gateway_subnet_address_prefix = "10.172.16.32/28"
cluster_subnet_address_prefix             = "10.172.16.48/28"
cluster_ingress_subnet_address_prefix     = "10.172.16.64/29"

# Private resources
aks_private_cluster_enabled              = true
enable_storage_blob_private_endpoint     = true
storage_blob_private_endpoint_ip_address = "10.172.16.4"
enable_sql_private_endpoint              = true
sql_private_endpoint_ip_address          = "10.172.16.5"
enable_vault_private_endpoint            = true
vault_private_endpoint_ip_address        = "10.172.16.6"
