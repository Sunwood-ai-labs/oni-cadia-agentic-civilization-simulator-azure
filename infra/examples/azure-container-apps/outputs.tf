output "resource_group_name" {
  value = azurerm_resource_group.demo.name
}

output "container_app_environment_name" {
  value = azurerm_container_app_environment.demo.name
}

output "mattermost_fqdn" {
  value = azurerm_container_app.mattermost.ingress[0].fqdn
}

output "mattermost_url" {
  value = "https://${azurerm_container_app.mattermost.ingress[0].fqdn}"
}

output "azure_citizen_app_names" {
  value = [for app in azurerm_container_app.citizen : app.name]
}

output "budget_name" {
  value = azurerm_consumption_budget_subscription.half_credit.name
}
