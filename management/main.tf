locals {
  rg_location = var.resource_group_location
  ghr_rg_name     = "az-lx-rg-ghr-hrw-${var.subscription_env}"
  ghr_vnet_name   = "az-lx-vnet-ghr-hrw-${var.subscription_env}"
}

// GitHub Runner Resource Group
module "ghrrg" {
  source = "./modules/rg"
  name     = local.ghr_rg_name
  location = local.rg_location
}

// GitHub Runner Virtual Netowrk
module "ghrvnet" {
  source = "./modules/vnet"

  rg_name     = local.ghr_rg_name
  rg_location = local.rg_location
  vnet_name   = local.ghr_vnet_name

  address_prefix = var.ghr_vnet_address_prefix
  dns_servers    = var.vnet_dns_servers
  depends_on = [
    module.ghrrg
  ]
}

// GitHub Runner
module "ghr" {
  source = "./modules/ghr"
  rg_name          = local.ghr_rg_name
  rg_location      = local.rg_location
  vnet_name        = local.ghr_vnet_name
  gh_pat           = var.gh_pat
  gh_runners_subnet_address_prefix = var.gh_runners_subnet_address_prefix
  depends_on = [
    module.ghrvnet
  ]
}

// HRW Environments (multiple) based on "var.environments"
/*module "hrwrg" {
  count = length(var.environments)

  source = "./modules/rg"

  location = local.rg_location
  name      = "az-lx-rg-hrw-${var.environments[count.index].env_name}"
}*/

data "azurerm_virtual_network" "hrwvnet" {
  count = length(var.environments)

  name   = "az-lx-vnet-hrw-${var.environments[count.index].env_name}"
  resource_group_name  = "az-lx-rg-hrw-${var.environments[count.index].env_name}"
}

resource "azurerm_virtual_network_peering" "hrwpeer" {
  count = length(var.environments)

  name                      = "az-lx-peer-ghr-hrw-${var.environments[count.index].env_name}"
  resource_group_name       = local.ghr_rg_name
  virtual_network_name      = local.ghr_vnet_name
  remote_virtual_network_id = data.azurerm_virtual_network.hrwvnet[count.index].id
}

resource "azurerm_virtual_network_peering" "ghrpeer" {
  count = length(var.environments)
  
  name                      = "az-lx-peer-hrw-${var.environments[count.index].env_name}-ghr"
  resource_group_name       = "az-lx-rg-hrw-${var.environments[count.index].env_name}"
  virtual_network_name      = "az-lx-vnet-hrw-${var.environments[count.index].env_name}"
  remote_virtual_network_id = module.ghrvnet.vnet_id
}
