module "resource_group_wireapps" {
  source = "../modules/resource-group"

  name        = "rg-${var.department}-${var.app_acronym}-${var.env_acronym}-${var.region_acronym}"
  description = "Resource Group"
  location    = "eastus"

  tags = var.tags
}
