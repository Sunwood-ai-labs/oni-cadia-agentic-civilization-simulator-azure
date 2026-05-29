terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "demo" {
  name                = "${var.name_prefix}-law"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "demo" {
  name                       = "${var.name_prefix}-aca-env"
  location                   = azurerm_resource_group.demo.location
  resource_group_name        = azurerm_resource_group.demo.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.demo.id
}

resource "azurerm_container_app" "mattermost" {
  name                         = "${var.name_prefix}-mattermost"
  container_app_environment_id = azurerm_container_app_environment.demo.id
  resource_group_name          = azurerm_resource_group.demo.name
  revision_mode                = "Single"

  ingress {
    external_enabled = true
    target_port      = 8065

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name   = "mattermost"
      image  = "mattermost/mattermost-preview:11.5.1"
      cpu    = 0.5
      memory = "1Gi"
    }
  }
}

resource "azurerm_container_app" "citizen" {
  for_each                     = var.azure_citizens
  name                         = "${var.name_prefix}-openclaw-${each.key}"
  container_app_environment_id = azurerm_container_app_environment.demo.id
  resource_group_name          = azurerm_resource_group.demo.name
  revision_mode                = "Single"

  secret {
    name  = "mattermost-bot-token"
    value = each.value.mattermost_bot_token
  }

  secret {
    name  = "azure-openai-api-key"
    value = var.azure_openai_api_key
  }

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name   = "openclaw"
      image  = var.openclaw_citizen_image
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "OPENCLAW_CITIZEN_HANDLE"
        value = each.key
      }

      env {
        name  = "OPENCLAW_CITIZEN_DISPLAY_NAME"
        value = each.value.display_name
      }

      env {
        name        = "OPENCLAW_MATTERMOST_BOT_TOKEN"
        secret_name = "mattermost-bot-token"
      }

      env {
        name        = "AZURE_OPENAI_API_KEY"
        secret_name = "azure-openai-api-key"
      }
    }
  }
}
