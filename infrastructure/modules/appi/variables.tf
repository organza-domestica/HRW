variable "log_workspace_name" {
  type = string
}

variable "appi_name" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

# variable "web_app_name" {
#   type = string
# }

variable "daily_quota_gb" {
  type = number
}

variable "log_analytics_retention_in_days" {
  type = number
}
