terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.63.0"
    }
  }
}

provider "azurerm" {
  features {

  }
  subscription_id = "69beffef-acb9-4f11-b7d5-7cba2b6d7b28"
  tenant_id = "23ad1223-7ac8-433e-97b5-8c1d731b844f"

}