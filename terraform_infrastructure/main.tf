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

output "static_web_app_id" {
  value = azurerm_static_site.this.id
  description = "Id for static site app"
}

output "default_host_name" {
  value = azurerm_static_site.this.default_host_name
  description = "Host name for static site"
}

output "api_key" {
  value = azurerm_static_site.this.api_key
  description = "API key used by GitHubAction for static web app"
}
