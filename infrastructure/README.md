<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =3.24.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.24.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | ./modules/aks | n/a |
| <a name="module_appi"></a> [appi](#module\_appi) | ./modules/appi | n/a |
| <a name="module_cr"></a> [cr](#module\_cr) | ./modules/cr | n/a |
| <a name="module_kv"></a> [kv](#module\_kv) | ./modules/kv | n/a |
| <a name="module_sql"></a> [sql](#module\_sql) | ./modules/sql | n/a |
| <a name="module_sql_pep"></a> [sql\_pep](#module\_sql\_pep) | ./modules/pep | n/a |
| <a name="module_st"></a> [st](#module\_st) | ./modules/st | n/a |
| <a name="module_st_pep"></a> [st\_pep](#module\_st\_pep) | ./modules/pep | n/a |
| <a name="module_vault_pep"></a> [vault\_pep](#module\_vault\_pep) | ./modules/pep | n/a |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | ./modules/vnet | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.24.0/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_hrw_url"></a> [app\_hrw\_url](#input\_app\_hrw\_url) | n/a | `string` | `"https://lm-web-hrw-dev.azurewebsites.net"` | no |
| <a name="input_azure_acr_helm_password"></a> [azure\_acr\_helm\_password](#input\_azure\_acr\_helm\_password) | n/a | `string` | `""` | no |
| <a name="input_azure_acr_helm_username"></a> [azure\_acr\_helm\_username](#input\_azure\_acr\_helm\_username) | n/a | `string` | `""` | no |
| <a name="input_azure_kv_sp_secret"></a> [azure\_kv\_sp\_secret](#input\_azure\_kv\_sp\_secret) | n/a | `string` | `""` | no |
| <a name="input_azuread_client_id"></a> [azuread\_client\_id](#input\_azuread\_client\_id) | n/a | `string` | `"f84e930b-849a-4861-bec0-c20be5e79edc"` | no |
| <a name="input_azuread_redirect_uri"></a> [azuread\_redirect\_uri](#input\_azuread\_redirect\_uri) | n/a | `string` | `"https://lm-web-hrw-dev.azurewebsites.net/login"` | no |
| <a name="input_deploy_private_endpoints"></a> [deploy\_private\_endpoints](#input\_deploy\_private\_endpoints) | n/a | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_externalapi_hrwservice"></a> [externalapi\_hrwservice](#input\_externalapi\_hrwservice) | n/a | `string` | `"https://hrwservice-be-azure.dv11-be.tl.pl/HRW/Service/api/"` | no |
| <a name="input_k8s_argocd_app_of_apps_repo_key"></a> [k8s\_argocd\_app\_of\_apps\_repo\_key](#input\_k8s\_argocd\_app\_of\_apps\_repo\_key) | n/a | `string` | `""` | no |
| <a name="input_log_analytics_daily_quota_gb"></a> [log\_analytics\_daily\_quota\_gb](#input\_log\_analytics\_daily\_quota\_gb) | n/a | `number` | `0.5` | no |
| <a name="input_redis_pep_ip_configurations"></a> [redis\_pep\_ip\_configurations](#input\_redis\_pep\_ip\_configurations) | n/a | `map(any)` | <pre>{<br>  "redisCache": "10.172.16.7"<br>}</pre> | no |
| <a name="input_sql_administrator_login"></a> [sql\_administrator\_login](#input\_sql\_administrator\_login) | n/a | `string` | n/a | yes |
| <a name="input_sql_pep_ip_configurations"></a> [sql\_pep\_ip\_configurations](#input\_sql\_pep\_ip\_configurations) | n/a | `map(any)` | <pre>{<br>  "sqlServer": "10.172.16.6"<br>}</pre> | no |
| <a name="input_st_pep_ip_configurations"></a> [st\_pep\_ip\_configurations](#input\_st\_pep\_ip\_configurations) | n/a | `map(any)` | <pre>{<br>  "blob": "10.172.16.5"<br>}</pre> | no |
| <a name="input_vault_pep_ip_configurations"></a> [vault\_pep\_ip\_configurations](#input\_vault\_pep\_ip\_configurations) | n/a | `map(any)` | <pre>{<br>  "vault": "10.172.16.8"<br>}</pre> | no |
| <a name="input_web_pep_ip_configurations"></a> [web\_pep\_ip\_configurations](#input\_web\_pep\_ip\_configurations) | n/a | `map(any)` | <pre>{<br>  "sites": "10.172.16.4"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kube_config_aks"></a> [kube\_config\_aks](#output\_kube\_config\_aks) | n/a |
<!-- END_TF_DOCS -->