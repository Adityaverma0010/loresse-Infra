resource "azurerm_resource_group" "container_env" {
  name     = "rg-cae-aios-pre-eastus"
  location = var.location
}

resource "azurerm_resource_group" "keyvault" {
  name     = "rg-kv-aios-pre-eastus"
  location = var.location
}

resource "azurerm_resource_group" "openai" {
  name     = "rg-openai-aios-pre-eastus"
  location = var.location
}

resource "azurerm_resource_group" "email_communication" {
  name     = "rg-ecs-aios-pre-eastus"
  location = var.location
}

resource "azurerm_resource_group" "communication" {
  name     = "rg-comms-aios-pre-eastus"
  location = var.location
}

resource "azurerm_resource_group" "database" {
  name     = "rg-psql-aios-pre-eastus"
  location = var.location
}

resource "azurerm_resource_group" "storage" {
  name     = "rg-st-aios-pre-eastus"
  location = var.location
}

module "containerapps" {
  source              = "../../modules/containerapps"
  resource_group_name = azurerm_resource_group.container_env.name
  location            = var.location
  env_name            = "cae-aios-pre-eastus"
  apps = {
    tc  = "aca-aios-ls-pre-eastus"
    ui  = "aca-aios-ui-pre-eastus"
    api = "aca-aios-api-pre-eastus"
  }
}

module "keyvault" {
  source              = "../../modules/keyvault"
  resource_group_name = azurerm_resource_group.keyvault.name
  location            = var.location
  kv_name             = "kv-aios-pre-eastus"
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

module "openai" {
  source              = "../../modules/openai"
  resource_group_name = azurerm_resource_group.openai.name
  location            = var.location
  name                = "openai-aios-pre-eastus"
}

module "ecs" {
  source              = "../../modules/ecs"
  resource_group_name = azurerm_resource_group.email_communication.name
  location            = var.location
  services = {
    email = "ecs-aios-pre-eastus"
  }
}

module "communication" {
  source              = "../../modules/communication"
  resource_group_name = azurerm_resource_group.communication.name
  location            = var.location
  services = {
    communication = "comms-aios-pre-eastus"
  }
}

module "database" {
  source              = "../../modules/database"
  resource_group_name = azurerm_resource_group.database.name
  location            = var.location
  db_name             = "psql-aios-pre-eastus"
}

module "storage" {
  source              = "../../modules/storage"
  resource_group_name = azurerm_resource_group.storage.name
  location            = var.location
  storage_account_name = "staiospreastus"
}
