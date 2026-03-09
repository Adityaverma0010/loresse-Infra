
data "azurerm_virtual_network" "existing" {
  name                = var.vnet_config.name
  resource_group_name = var.vnet_config.resource_group_name
}

resource "azurerm_subnet" "container_apps" {
  for_each = var.subnet_configs

  name                 = "subnet-${each.key}-cae"
  resource_group_name  = var.vnet_config.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.existing.name
  address_prefixes     = each.value.address_prefixes

  delegation {
    name = "Microsoft.App.environments"

    service_delegation {
      name    = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_container_app_environment" "envs" {
  for_each = var.container_apps_config.apps

  name                       = "${var.container_apps_config.env_name}-${each.key}"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.container_env.name
  infrastructure_subnet_id   = azurerm_subnet.container_apps[each.key].id
}

resource "azurerm_resource_group" "container_env" {
  name     = var.resource_group_names["container_env"]
  location = var.location
}

resource "azurerm_resource_group" "keyvault" {
  name     = var.resource_group_names["keyvault"]
  location = var.location
}

resource "azurerm_resource_group" "openai" {
  name     = var.resource_group_names["openai"]
  location = var.location
}

resource "azurerm_resource_group" "email_communication" {
  name     = var.resource_group_names["email_communication"]
  location = var.location
}

resource "azurerm_resource_group" "communication" {
  name     = var.resource_group_names["communication"]
  location = var.location
}

resource "azurerm_resource_group" "database" {
  name     = var.resource_group_names["database"]
  location = var.location
}

resource "azurerm_resource_group" "storage" {
  name     = var.resource_group_names["storage"]
  location = var.location
}

module "containerapps_login" {
  source              = "../../modules/containerapps"
  resource_group_name = azurerm_resource_group.container_env.name
  location            = var.location
  environment_id      = azurerm_container_app_environment.envs["login"].id
  apps = {
    login = var.container_apps_config.apps["login"]
  }
}

module "containerapps_ui" {
  source              = "../../modules/containerapps"
  resource_group_name = azurerm_resource_group.container_env.name
  location            = var.location
  environment_id      = azurerm_container_app_environment.envs["ui"].id
  apps = {
    ui = var.container_apps_config.apps["ui"]
  }
}

module "containerapps_api" {
  source              = "../../modules/containerapps"
  resource_group_name = azurerm_resource_group.container_env.name
  location            = var.location
  environment_id      = azurerm_container_app_environment.envs["api"].id
  apps = {
    api = var.container_apps_config.apps["api"]
  }
}

module "keyvault" {
  source              = "../../modules/keyvault"
  resource_group_name = azurerm_resource_group.keyvault.name
  location            = var.location
  kv_name             = var.keyvault_config.kv_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

module "openai" {
  source              = "../../modules/openai"
  resource_group_name = azurerm_resource_group.openai.name
  location            = var.location
  name                = var.openai_config.name
}

module "ecs" {
  source              = "../../modules/ecs"
  resource_group_name = azurerm_resource_group.email_communication.name
  location            = var.location
  services            = var.ecs_config.services
}

module "communication" {
  source              = "../../modules/communication"
  resource_group_name = azurerm_resource_group.communication.name
  location            = var.location
  services            = var.communication_config.services
}

module "database" {
  source              = "../../modules/database"
  resource_group_name = azurerm_resource_group.database.name
  location            = var.location
  db_name             = var.database_config.db_name
}

module "storage" {
  source               = "../../modules/storage"
  resource_group_name  = azurerm_resource_group.storage.name
  location             = var.location
  storage_account_name = var.storage_config.storage_account_name
}

data "azurerm_client_config" "current" {}

