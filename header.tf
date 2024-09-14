terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.1.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "lne-rg"
    storage_account_name = "lneterraformstatefiles"
    container_name       = "terraform-state-files"
    key                  = "01.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "0fd48776-0395-4bd9-b209-cd657e8be24d"
}