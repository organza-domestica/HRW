<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.appi_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.appi_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_blob_storage_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.docker_registry_server_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.docker_registry_server_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.docker_registry_server_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.hangfire_database_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.hrw_database_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.sql_server_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_application_insights.appi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_container_registry.cr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_registry) | data source |
| [azurerm_mssql_database.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/mssql_database) | data source |
| [azurerm_mssql_server.sql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/mssql_server) | data source |
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appi_name"></a> [appi\_name](#input\_appi\_name) | n/a | `string` | n/a | yes |
| <a name="input_cr_name"></a> [cr\_name](#input\_cr\_name) | n/a | `string` | n/a | yes |
| <a name="input_kv_secret_name_appi_connection_string"></a> [kv\_secret\_name\_appi\_connection\_string](#input\_kv\_secret\_name\_appi\_connection\_string) | n/a | `string` | n/a | yes |
| <a name="input_kv_secret_name_appi_key"></a> [kv\_secret\_name\_appi\_key](#input\_kv\_secret\_name\_appi\_key) | n/a | `string` | n/a | yes |
| <a name="input_kv_secret_name_azure_blob_storage_connection_string"></a> [kv\_secret\_name\_azure\_blob\_storage\_connection\_string](#input\_kv\_secret\_name\_azure\_blob\_storage\_connection\_string) | n/a | `string` | n/a | yes |
| <a name="input_kv_secret_name_docker_registry_server_password"></a> [kv\_secret\_name\_docker\_registry\_server\_password](#input\_kv\_secret\_name\_docker\_registry\_server\_password) | n/a | `string` | n/a | yes |
| <a name="input_kv_secret_name_docker_registry_server_url"></a> [kv\_secret\_name\_docker\_registry\_server\_url](#input\_kv\_secret\_name\_docker\_registry\_server\_url) | n/a | `string` | n/a | yes |
| <a name="input_kv_secret_name_docker_registry_server_username"></a> [kv\_secret\_name\_docker\_registry\_server\_username](#input\_kv\_secret\_name\_docker\_registry\_server\_username) | n/a | `string` | n/a | yes |
| <a name="input_kv_secret_name_hangfire_database_connection_string"></a> [kv\_secret\_name\_hangfire\_database\_connection\_string](#input\_kv\_secret\_name\_hangfire\_database\_connection\_string) | n/a | `string` | n/a | yes |
| <a name="input_kv_secret_name_hrw_database_connection_string"></a> [kv\_secret\_name\_hrw\_database\_connection\_string](#input\_kv\_secret\_name\_hrw\_database\_connection\_string) | n/a | `string` | n/a | yes |
| <a name="input_kv_secret_name_sql_server_admin_password"></a> [kv\_secret\_name\_sql\_server\_admin\_password](#input\_kv\_secret\_name\_sql\_server\_admin\_password) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_rg_location"></a> [rg\_location](#input\_rg\_location) | n/a | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | n/a | `string` | n/a | yes |
| <a name="input_sql_db_name"></a> [sql\_db\_name](#input\_sql\_db\_name) | n/a | `string` | n/a | yes |
| <a name="input_sql_db_password"></a> [sql\_db\_password](#input\_sql\_db\_password) | n/a | `string` | n/a | yes |
| <a name="input_sql_server_name"></a> [sql\_server\_name](#input\_sql\_server\_name) | n/a | `string` | n/a | yes |
| <a name="input_storage_name"></a> [storage\_name](#input\_storage\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_uri"></a> [uri](#output\_uri) | n/a |
<!-- END_TF_DOCS -->