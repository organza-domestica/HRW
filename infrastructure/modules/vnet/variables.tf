variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "address_prefix" {
  type = string
}

variable "dns_servers" {
  type = list(string)
}

variable "private_endpoints_subnet_address_prefix" {
  type = string
}

variable "application_gateway_subnet_address_prefix" {
  type = string
}

variable "cluster_subnet_address_prefix" {
  type = string
}

variable "cluster_ingress_subnet_address_prefix" {
  type = string
}

# variable "hub_remote_virtual_network_id" {
#   type = string
# }
