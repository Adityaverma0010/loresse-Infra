resource "azurerm_postgresql_flexible_server" "db" {
  name                = var.db_name
  resource_group_name = var.resource_group_name
  location            = var.location
  administrator_login = "pgadmin"
  administrator_password = "SuperSecurePassword123!"
  sku_name            = "B_Standard_B1ms"
  storage_mb          = 32768
  version             = "13"
}
