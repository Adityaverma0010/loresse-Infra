terraform {
  backend "azurerm" {
    resource_group_name  = "strg-rg"
    storage_account_name = "strg0007"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
  }
}