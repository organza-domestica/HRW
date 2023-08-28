## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.99.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.vm_gh_runner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.nic_gh_runner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.nsg_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.nsg_gh_runners](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.my_terraform_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_storage_account.gh_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_subnet.snet_gh_runners_mgmt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [tls_private_key.auto_ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [template_file.linux-vm-cloud-init](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gh_pat"></a> [gh\_pat](#input\_gh\_pat) | Personal Authentication Token used for registering GitHub Runners | `string` | `""` | no |
| <a name="input_gh_runners_subnet_address_prefix"></a> [gh\_runners\_subnet\_address\_prefix](#input\_gh\_runners\_subnet\_address\_prefix) | Subnet of Virtual Network to deploy GitHub Runner to | `string` | `""` | no |
| <a name="input_rg_location"></a> [rg\_location](#input\_rg\_location) | Location for created GitHub Runner, e.g. 'westeurope' | `string` | `"westeurope"` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Name of Resource Group to deploy GitHub Runner to, e.g. 'dev' | `string` | `"dev"` | no |
| <a name="input_subscription_env"></a> [subscription\_env](#input\_subscription\_env) | Subscription to deploy GitHub Runner to, e.g. 'devtest' | `string` | `"devtest"` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of Virtual Network to deploy GitHub Runner to | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_tls_private_key"></a> [tls\_private\_key](#output\_tls\_private\_key) | n/a |
