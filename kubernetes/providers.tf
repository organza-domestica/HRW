terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.39.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }

  backend "azurerm" {
    use_azuread_auth = true
    # resource_group_name  = "az-lx-rg-tf-hrw-devtest"
    # storage_account_name = "azlxsttfhrwdevtest"
    # container_name       = "tfstate"
    # key                  = "az-lx-hrw-dev.tfstate"
    #use_microsoft_graph  = false
  }
}

provider "azurerm" {
  features {}

  skip_provider_registration = true
}
