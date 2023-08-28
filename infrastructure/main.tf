terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.39.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
  }

  backend "azurerm" {
    use_azuread_auth = true
  }
}

provider "azurerm" {
  features {}

  skip_provider_registration = true
}

data "azurerm_client_config" "current" {}

locals {
  rg_name     = "az-lx-rg-hrw-${var.environment}"
  rg_location = "West Europe"

  cr_name            = "azlxcrhrw${var.environment}"
  kv_name            = "az-lx-kv-hrw-${var.environment}"
  kv_pep_name        = "az-lx-pep-kv-hrw-${var.environment}"
  kv_pep_nic_name    = "az-lx-nic-pep-kv-hrw-${var.environment}"
  id_name            = "az-lx-id-hrw-${var.environment}-aks"
  id_sql_server_name = "az-lx-id-sql-hrw-${var.environment}"
  id_storage_name    = "az-lx-id-st-hrw-${var.environment}"

  kv_secret_name_sql_server_admin_password = "sqlServerAdminPassword"

  log_workspace_name   = "az-lx-log-hrw-${var.environment}"
  appi_name            = "az-lx-appi-hrw-${var.environment}"
  st_name              = "azlxsthrw${var.environment}"
  st_blob_pep_name     = "az-lx-pep-blob-sthrw${var.environment}"
  st_blob_pep_nic_name = "az-lx-nic-pep-blob-sthrw${var.environment}"
  sql_server_name      = "az-lx-sql-hrw-${var.environment}"
  sql_db_name          = "hrw"
  sql_pep_name         = "az-lx-pep-sql-hrw-${var.environment}"
  sql_pep_nic_name     = "az-lx-nic-pep-sql-hrw-${var.environment}"
  aks_name             = "az-lx-aks-hrw-${var.environment}"
  vnet_name            = "az-lx-vnet-hrw-${var.environment}"
}


module "st" {
  source = "./modules/st"

  name             = local.st_name
  rg_name          = local.rg_name
  rg_location      = local.rg_location
  replication_type = var.storage_replication_type

  private_endpoint_subnet_id = module.vnet.private_endpoints_subnet_id

  enable_blob_private_endpoint     = var.enable_storage_blob_private_endpoint
  blob_private_endpoint_ip_address = var.storage_blob_private_endpoint_ip_address
  blob_private_endpoint_name       = local.st_blob_pep_name
  blob_private_endpoint_nic_name   = local.st_blob_pep_nic_name

  cmk_encryption_umi_id = module.kv.storage_identity_id
  cmk_encryption_key_id = module.kv.data_encryption_key_versionless_id

  log_analytics_workspace_id = module.appi.log_analytics_workspace_id
}

module "appi" {
  source = "./modules/appi"

  log_workspace_name              = local.log_workspace_name
  appi_name                       = local.appi_name
  rg_name                         = local.rg_name
  rg_location                     = local.rg_location
  daily_quota_gb                  = var.log_analytics_daily_quota_gb
  log_analytics_retention_in_days = var.log_analytics_retention_in_days
}


module "cr" {
  source = "./modules/cr"

  name        = local.cr_name
  rg_name     = local.rg_name
  rg_location = local.rg_location
  sku         = var.container_registry_sku

  log_analytics_workspace_id = module.appi.log_analytics_workspace_id
}

module "kv" {

  source = "./modules/kv"

  rg_name     = local.rg_name
  rg_location = local.rg_location
  name        = local.kv_name

  private_endpoint_subnet_id = module.vnet.private_endpoints_subnet_id

  enable_private_endpoint     = var.enable_vault_private_endpoint
  private_endpoint_ip_address = var.vault_private_endpoint_ip_address
  private_endpoint_name       = local.kv_pep_name
  private_endpoint_nic_name   = local.kv_pep_nic_name

  kv_secret_name_sql_server_admin_password = local.kv_secret_name_sql_server_admin_password
  id_name                                  = local.id_name
  id_sql_server_name                       = local.id_sql_server_name
  id_storage_name                          = local.id_storage_name

  log_analytics_workspace_id = module.appi.log_analytics_workspace_id
}

module "sql" {
  depends_on = [
    module.st
  ]

  source = "./modules/sql"

  rg_name                                       = local.rg_name
  rg_location                                   = local.rg_location
  sql_server_name                               = local.sql_server_name
  sql_db_name                                   = local.sql_db_name
  sql_azuread_administrator_id                  = var.sql_azuread_administrator_id
  sql_azuread_administrator_login               = var.sql_azuread_administrator_login
  sql_administrator_login                       = var.sql_administrator_login
  sql_administrator_password                    = module.kv.sql_administrator_password
  sql_server_auditing_storage_retention_in_days = var.sql_server_storage_auditing_retention_in_days
  sql_db_sku_name                               = var.sql_db_sku_name
  sql_db_max_size_gb                            = var.sql_db_max_size_gb
  sql_db_short_term_retention_in_days           = var.sql_db_short_term_retention_in_days
  auditing_storage_id                           = module.st.id
  auditing_storage_blob_endpoint                = module.st.primary_blob_endpoint

  private_endpoint_subnet_id = module.vnet.private_endpoints_subnet_id

  enable_private_endpoint     = var.enable_sql_private_endpoint
  private_endpoint_ip_address = var.sql_private_endpoint_ip_address
  private_endpoint_name       = local.sql_pep_name
  private_endpoint_nic_name   = local.sql_pep_nic_name

  tde_cmk_encryption_umi_id           = module.kv.sql_server_identity_id
  tde_cmk_encryption_key_id           = module.kv.data_encryption_key_id
  tde_cmk_encryption_umi_principal_id = module.kv.sql_server_identity_principal_id

  log_analytics_workspace_id = module.appi.log_analytics_workspace_id
}

module "aks" {
  source = "./modules/aks"

  resource_group_name             = local.rg_name
  location                        = local.rg_location
  cluster_name                    = local.aks_name
  environment                     = var.environment
  virtual_network_subnet_id       = module.vnet.cluster_subnet_id
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  application_client_id           = data.azurerm_client_config.current.client_id
  application_client_secret       = var.azure_kv_sp_secret
  kv_uri                          = module.kv.uri
  umi_client_id                   = module.kv.umi_client_id
  umi_id                          = module.kv.umi_id
  log_analytics_workspace_id      = module.appi.log_analytics_workspace_id
  registry_server_url             = module.cr.login_server
  docker_registry_server_username = module.cr.admin_username
  docker_registry_server_password = module.cr.admin_password
  azure_acr_helm_username         = var.azure_acr_helm_username
  azure_acr_helm_password         = var.azure_acr_helm_password
  argocd_app_of_apps_repo_key     = var.k8s_argocd_app_of_apps_repo_key
  private_cluster_enabled         = var.aks_private_cluster_enabled
  admin_group_object_id           = var.aks_admin_group_object_id
  service_principal_secret        = var.service_principal_secret
}

module "vnet" {
  source = "./modules/vnet"

  rg_name     = local.rg_name
  rg_location = local.rg_location
  vnet_name   = local.vnet_name
  environment = var.environment

  address_prefix = var.vnet_address_prefix
  dns_servers    = var.vnet_dns_servers

  private_endpoints_subnet_address_prefix   = var.private_endpoints_subnet_address_prefix
  application_gateway_subnet_address_prefix = var.application_gateway_subnet_address_prefix
  cluster_subnet_address_prefix             = var.cluster_subnet_address_prefix
  cluster_ingress_subnet_address_prefix     = var.cluster_ingress_subnet_address_prefix

  # hub_remote_virtual_network_id = "/subscriptions/c48e6978-89d1-4c91-b27c-0056ebcb5704/resourceGroups/lx-rg-conn-001/providers/Microsoft.Network/virtualNetworks/lx-vnet-hub-conn-westeu-001"
}
