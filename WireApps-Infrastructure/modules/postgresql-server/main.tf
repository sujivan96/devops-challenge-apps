resource "random_password" "password" {
  count = (var.admin_password == "" ? 1 : 0)

  length           = 32
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  special          = true
  override_special = "!@#$%*()-_=+[]{}:?"
}

resource "azurerm_postgresql_server" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "B_Gen5_1"
    capacity = 1
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = var.administrator_login
  administrator_login_password = local.admin_password

  version = "11"
  ssl_enforcement_enabled = true
}

resource "azurerm_postgresql_database" "main" {
  name                = var.postgresql_database
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.main.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}