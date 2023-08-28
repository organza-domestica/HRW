variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "vnet_name" {
  type = string
}

//variable "environment" {
//  type = string
//}

variable "address_prefix" {
  type = string
}

variable "dns_servers" {
  type = list(string)
}

# variable "hub_remote_virtual_network_id" {
#   type = string
# }
