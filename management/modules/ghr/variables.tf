variable "subscription_env" {
  type    = string
  nullable = false
  default = "devtest"
  description = "Subscription to deploy GitHub Runner to, e.g. 'devtest'"
}

variable "rg_name" {
  type    = string
  nullable = false
  default = "dev"
  description = "Name of Resource Group to deploy GitHub Runner to, e.g. 'dev'"
}

variable "rg_location" {
  type    = string
  nullable = false
  default = "westeurope"
  description = "Location for created GitHub Runner, e.g. 'westeurope'"
}

variable "gh_pat" {
  type    = string
  nullable = false
  default     = ""
  description = "Personal Authentication Token used for registering GitHub Runners"
}

variable "vnet_name" {
  type    = string
  nullable = false
  default     = ""
  description = "Name of Virtual Network to deploy GitHub Runner to"
}

variable "gh_runners_subnet_address_prefix" {
  type    = string
  nullable = false
  default     = ""
  description = "Subnet of Virtual Network to deploy GitHub Runner to"
}
