output "kube_config_aks" {
  value     = module.aks.kube_config
  sensitive = true
}
