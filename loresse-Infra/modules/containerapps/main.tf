resource "azurerm_container_app_environment" "env" {
  name                = var.env_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_container_app" "apps" {
  for_each            = var.apps
  name                = each.value
  resource_group_name = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.env.id

  revision_mode = "Single"

  template {
    container {
      name   = each.key
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}
