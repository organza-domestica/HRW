output "public_ip_address" {
  value = module.ghr.public_ip_address
}

output "tls_private_key" {
  value     = module.ghr.tls_private_key
  sensitive = true
}

