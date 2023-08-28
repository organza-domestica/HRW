variable "name" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "replication_type" {
  type = string
}

variable "enable_blob_private_endpoint" {
  type = bool
}

variable "private_endpoint_subnet_id" {
  type = string
}

variable "blob_private_endpoint_name" {
  type = string
}

variable "blob_private_endpoint_nic_name" {
  type = string
}

variable "blob_private_endpoint_ip_address" {
  type = string
}

variable "cmk_encryption_umi_id" {
  type = string
}

variable "cmk_encryption_key_id" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}
