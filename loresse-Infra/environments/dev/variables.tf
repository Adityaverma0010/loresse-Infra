variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}
variable "resource_group_names" {
  description = "Names for resource groups"
  type        = map(string)
  default = {
    container_env          = "rg-cae-aios-dev-eastus"
    keyvault               = "rg-kv-aios-dev-eastus"
    openai                 = "rg-openai-aios-dev-eastus"
    email_communication    = "rg-ecs-aios-dev-eastus"
    communication          = "rg-comms-aios-dev-eastus"
    database               = "rg-psql-aios-dev-eastus"
    storage                = "rg-st-aios-dev-eastus"
  }
}

variable "container_apps_config" {
  description = "Container Apps configuration"
  type = object({
    env_name = string
    apps     = map(string)
  })
}

variable "keyvault_config" {
  description = "Key Vault configuration"
  type = object({
    kv_name = string
  })
}

variable "openai_config" {
  description = "OpenAI configuration"
  type = object({
    name = string
  })
}

variable "ecs_config" {
  description = "ECS configuration"
  type = object({
    services = map(string)
  })
}

variable "communication_config" {
  description = "Communication configuration"
  type = object({
    services = map(string)
  })
}

variable "database_config" {
  description = "Database configuration"
  type = object({
    db_name = string
  })
}

variable "storage_config" {
  description = "Storage configuration"
  type = object({
    storage_account_name = string
  })
}

variable "vnet_config" {
  description = "Existing VNet configuration"
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "subnet_configs" {
  description = "Subnet configurations for container apps"
  type = map(object({
    address_prefixes = list(string)
  }))
  default = {
    login-app = {
      address_prefixes = ["10.0.1.0/24"]
    }
    ui-app = {
      address_prefixes = ["10.0.2.0/24"]
    }
    api-app = {
      address_prefixes = ["10.0.3.0/24"]
    }
  }
}