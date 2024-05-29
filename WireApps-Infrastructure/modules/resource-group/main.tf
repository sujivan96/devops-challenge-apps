# Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "main" {
  name     = var.name
  location = var.location

  tags = merge(
    var.tags,
    {
      Description = var.description
    }
  )

}

# Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "contributor" {
  for_each = toset(var.contributors)

  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = each.key
}

# Azure built-in roles: https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
resource "azurerm_role_assignment" "monitoring_contributor" {
  for_each = toset(var.monitoring_contributor_objects_ids)

  scope                = azurerm_resource_group.main.id
  role_definition_name = "Monitoring Contributor"
  principal_id         = each.key
}

resource "azurerm_role_assignment" "workbook_contributor" {
  for_each = toset(var.workbook_contributor_objects_ids)

  scope                = azurerm_resource_group.main.id
  role_definition_name = "Workbook Contributor"
  principal_id         = each.key
}

# Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
# Azure RBAC Docs: https://docs.microsoft.com/en-us/azure/azure-monitor/logs/manage-access?tabs=portal
resource "azurerm_role_assignment" "log_analytics_reader" {
  for_each = toset(var.log_analytics_reader_objects_ids)

  scope                = azurerm_resource_group.main.id
  role_definition_name = "Log Analytics Reader"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "monitoring_reader" {
  for_each = toset(var.monitoring_reader_objects_ids)

  scope                = azurerm_resource_group.main.id
  role_definition_name = "Monitoring Reader"
  principal_id         = each.value
}

# custom role to read UAT and Production AppInsight
resource "azurerm_role_assignment" "RIDES_appInsight_reader" {
  for_each = toset(var.RIDES_appInsight_reader_objects_ids)

  scope                = azurerm_resource_group.main.id
  role_definition_name = "RIDES AppInsight Reader RIDES Subscriptions"
  principal_id         = each.value
}
