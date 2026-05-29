resource "azurerm_resource_group" "demo" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "demo" {
  name                = "${var.name_prefix}-law"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_container_app_environment" "demo" {
  name                       = "${var.name_prefix}-aca-env"
  location                   = azurerm_resource_group.demo.location
  resource_group_name        = azurerm_resource_group.demo.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.demo.id
  tags                       = var.tags
}

resource "azurerm_container_app" "mattermost" {
  name                         = "${var.name_prefix}-mattermost"
  container_app_environment_id = azurerm_container_app_environment.demo.id
  resource_group_name          = azurerm_resource_group.demo.name
  revision_mode                = "Single"
  tags                         = var.tags

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
      image  = var.mattermost_image
      cpu    = var.mattermost_cpu
      memory = var.mattermost_memory

      env {
        name  = "MM_SERVICESETTINGS_LISTENADDRESS"
        value = ":8065"
      }

      env {
        name  = "MM_TEAMSETTINGS_ENABLEOPENSERVER"
        value = "true"
      }

      env {
        name  = "MM_SERVICESETTINGS_ENABLEBOTACCOUNTCREATION"
        value = "true"
      }

      env {
        name  = "MM_SERVICESETTINGS_ENABLEUSERACCESSTOKENS"
        value = "true"
      }

      env {
        name  = "TZ"
        value = "Asia/Tokyo"
      }
    }
  }
}

resource "azurerm_container_app" "citizen" {
  for_each                     = var.azure_citizens
  name                         = "${var.name_prefix}-openclaw-${each.key}"
  container_app_environment_id = azurerm_container_app_environment.demo.id
  resource_group_name          = azurerm_resource_group.demo.name
  revision_mode                = "Single"
  tags                         = var.tags

  secret {
    name  = "mattermost-bot-token"
    value = var.mattermost_bot_tokens[each.key]
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
      cpu    = var.citizen_cpu
      memory = var.citizen_memory

      env {
        name  = "OPENCLAW_CITIZEN_HANDLE"
        value = each.key
      }

      env {
        name  = "OPENCLAW_CITIZEN_DISPLAY_NAME"
        value = each.value.display_name
      }

      env {
        name  = "OPENCLAW_CITIZEN_INSTANCE"
        value = tostring(each.value.instance_id)
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

resource "azurerm_consumption_budget_subscription" "half_credit" {
  name            = "${var.name_prefix}-free-credit-half"
  subscription_id = "/subscriptions/${var.subscription_id}"
  amount          = var.budget_amount_jpy
  time_grain      = "Monthly"

  time_period {
    start_date = "2026-05-01T00:00:00Z"
    end_date   = "2026-06-30T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = var.budget_contact_emails
    contact_roles  = ["Owner"]
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Forecasted"
    contact_emails = var.budget_contact_emails
    contact_roles  = ["Owner"]
  }
}
