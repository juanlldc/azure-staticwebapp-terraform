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

resource "azurerm_resource_group" "az204" {
  name = local.projectname
  location = local.location
}

resource "azurerm_static_site" "az204" {
  name                = "az204staticwebapp"
  resource_group_name = azurerm_resource_group.az204.name
  location            = azurerm_resource_group.az204.location
}

output "static_web_app_id" {
  value = azurerm_static_site.az204.id
  description = "Id for static site app"
}

output "default_host_name" {
  value = azurerm_static_site.az204.default_host_name
  description = "Host name for static site"
}

output "api_key" {
  value = azurerm_static_site.az204.api_key
  description = "API key used by GitHubAction for static web app"
}
