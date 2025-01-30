terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.16.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "Korea South"
}

resource "azurerm_service_plan" "example" {
  name                = "example-app-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "Linux"
  sku_name            = "B1"
}
resource "azurerm_linux_web_app" "example" {
  name                = "example-web-app-codeseoul-beege" # Must be globally unique
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    container_registry_use_managed_identity = false

    application_stack {
      docker_image_name   = "nginx:latest"
      docker_registry_url = "https://index.docker.io"
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
  }
}

resource "azurerm_container_registry" "registry" {
  name                = "bootcamp"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_user_assigned_identity" "example" {
  location            = azurerm_resource_group.example.location
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_federated_identity_credential" "example" {
  name                = "bootcamp"
  resource_group_name = azurerm_resource_group.example.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.example.id
  subject             = "repo:CodeSeoul/seollal-bootcamp-2025-backend:environment:production"
}
