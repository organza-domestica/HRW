variable "subscription_env" {
  type    = string
  nullable = false
  default = "devtest"
  description = "Subscription to deploy GitHub Runner to"
}

variable "resource_group_location" {
  type    = string
  nullable = false
  default = "West Europe"
  description = "Resources location"
}

variable "gh_pat" {
  type    = string
  nullable = false
  default     = ""
  description = "Personal Authentication Token used for registering GitHub Runners"
}

variable "ghr_vnet_address_prefix" {
  type    = string
  nullable = false
  default = "10.173.16.0/24"
  description = "CICD assigned to given subscription"
}

variable "vnet_address_prefix" {
  type    = string
  nullable = false
  default = "10.172.16.0/24"
  description = "CICD assigned to given subscription"
}

variable "gh_runners_subnet_address_prefix" {
  type    = string
  nullable = false
  default = "10.173.16.48/28"
  description = ""
}

variable "vnet_dns_servers" {
  type    = list(string)
  nullable = false
  default = []
  description = "Set DNS servers for subscription. Uses Public DNS if empty array"
}

variable "environments" {
  type = list(object({
    env_name = string
    vnet_address_prefix = string
  }))
  nullable = false
  description = "Environments configuration"
  default = []
}
