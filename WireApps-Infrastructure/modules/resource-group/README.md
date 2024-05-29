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
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created. | `string` | `"eastus"` | no |
| <a name="input_name"></a> [name](#input\_name) | The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags which should be assigned to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Resource Group. |
<!-- BEGIN_TF_DOCS -->
The following documentation outlines the providers, resources, inputs, and outputs used in this Terraform configuration.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.RIDES_appInsight_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.log_analytics_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.monitoring_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.monitoring_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.workbook_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_RIDES_appInsight_reader_objects_ids"></a> [RIDES\_appInsight\_reader\_objects\_ids](#input\_RIDES\_appInsight\_reader\_objects\_ids) | Custom role to read UAT and Production AppInsight | `set(string)` | `[]` | no |
| <a name="input_contributors"></a> [contributors](#input\_contributors) | A list of users or principals that need contributor access to the resource group. | `list(string)` | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | A description for the resources (less than or equal to 512 characters). | `string` | `"A resource deployed by Terraform."` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created. | `string` | `"eastus"` | no |
| <a name="input_log_analytics_reader_objects_ids"></a> [log\_analytics\_reader\_objects\_ids](#input\_log\_analytics\_reader\_objects\_ids) | Log Analytics Reader can view and search all monitoring data as well as and view monitoring settings, including viewing the configuration of Azure diagnostics on all Azure resources. | `set(string)` | `[]` | no |
| <a name="input_monitoring_contributor_objects_ids"></a> [monitoring\_contributor\_objects\_ids](#input\_monitoring\_contributor\_objects\_ids) | Can read all monitoring data and edit monitoring settings. See also Get started with roles, permissions, and security with Azure Monitor. | `set(string)` | `[]` | no |
| <a name="input_monitoring_reader_objects_ids"></a> [monitoring\_reader\_objects\_ids](#input\_monitoring\_reader\_objects\_ids) | Can read all monitoring data (metrics, logs, etc.). See also Get started with roles, permissions, and security with Azure Monitor. | `set(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags which should be assigned to the resource. | `map(string)` | n/a | yes |
| <a name="input_workbook_contributor_objects_ids"></a> [workbook\_contributor\_objects\_ids](#input\_workbook\_contributor\_objects\_ids) | Can read all monitoring data and edit monitoring settings. See also Get started with roles, permissions, and security with Azure Monitor. | `set(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Resource Group. |
| <a name="output_location"></a> [location](#output\_location) | The location of the resource group. |
| <a name="output_name"></a> [name](#output\_name) | The name of the resource group. |
<!-- END_TF_DOCS -->