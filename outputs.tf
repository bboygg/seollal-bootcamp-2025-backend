output "registry_login_server" {
  value = azurerm_container_registry.registry.login_server
}

output "subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "tenant_id" {
  value = data.azurerm_subscription.current.tenant_id
}

output "identity_client_id" {
  value = azurerm_user_assigned_identity.example.client_id
}
