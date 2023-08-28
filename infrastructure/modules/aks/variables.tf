variable "resource_group_name" {}
variable "location" {}
variable "tenant_id" {}
variable "application_client_id" {}
variable "application_client_secret" {}

variable "cluster_name" {
  default = "az-lx-aks"
}

variable "environment" {
  default = "dev"
}

variable "ssh_public_key" {
  default = "modules/aks/keys/id_rsa.pub"
}

variable "agent_count" {
  default = 1
}

variable "dns_prefix" {
  default = "terraform-aks"
}

variable "kv_uri" {
  type = string
}

variable "umi_client_id" {
  type = string
}

variable "umi_id" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "registry_server_url" {
  type      = string
  sensitive = false
}

variable "docker_registry_server_username" {
  type      = string
  sensitive = true
}

variable "docker_registry_server_password" {
  type      = string
  sensitive = true
}

variable "argocd_app_of_apps_repo_key" {
  type      = string
  sensitive = true
}

variable "azure_acr_helm_username" {
}

variable "azure_acr_helm_password" {
  sensitive = true
}

variable "virtual_network_subnet_id" {
  type = string
}

variable "private_cluster_enabled" {
  type = bool
}

variable "admin_group_object_id" {
  type = string
}

variable "service_principal_secret" {
  type = string
}
