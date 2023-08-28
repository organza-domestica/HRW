variable "environment" {
  type = string
}

variable "service_principal_secret" {
  type      = string
  sensitive = true
}

variable "k8s_argocd_app_of_apps_repo_key" {
  type      = string
  sensitive = true
}

variable "azure_acr_helm_username" {
  type = string
}

variable "azure_acr_helm_password" {
  sensitive = true
}

variable "azure_kv_sp_secret" {
  type      = string
  sensitive = true
}

variable "sql_administrator_login" {
  type    = string
  default = ""
}
