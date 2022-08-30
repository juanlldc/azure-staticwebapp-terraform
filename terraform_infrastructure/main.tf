terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.17.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  projectname = "azure-staticwebapp-terraform"
  location = "centralus"
}

resource "azurerm_resource_group" "this" {
  name = local.projectname
  location = local.location
}

resource "azurerm_static_site" "this" {
  name                = local.projectname
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}
