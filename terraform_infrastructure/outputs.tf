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
