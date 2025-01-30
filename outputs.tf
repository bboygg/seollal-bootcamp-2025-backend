output "registry_login_server" {
    value = azurerm_container_registry.registry.login_server
}

output "registry_credentials" {
    value = azurerm_container_registry.registry.admin_username
}
