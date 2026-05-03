resource "azapi_resource" "this" {
  location       = var.location
  name           = var.name
  parent_id      = var.parent_id
  type           = "Microsoft.App/agents@2026-01-01"
  body           = local.resource_body
  create_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  delete_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  read_headers   = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null
  response_export_values = [
    "identity.principalId",
    "identity.tenantId",
    "properties.agentEndpoint",
    "properties.agentIdentity.clientId",
    "properties.agentIdentity.enabled"
  ]
  schema_validation_enabled = false
  sensitive_body = {
    properties = {
      incidentManagementConfiguration = var.incident_management_configuration == null ? null : {
        connectionKey = var.connection_key
      }
      logConfiguration = var.log_configuration == null ? null : {
        applicationInsightsConfiguration = {
          connectionString = var.connection_string
        }
      }
    }
  }
  sensitive_body_version = {
    "properties.incidentManagementConfiguration.connectionKey"                      = var.connection_key_version
    "properties.logConfiguration.applicationInsightsConfiguration.connectionString" = var.connection_string_version
  }
  tags           = var.tags
  update_headers = var.enable_telemetry ? { "User-Agent" : local.avm_azapi_header } : null

  dynamic "identity" {
    for_each = local.managed_identities.system_assigned_user_assigned

    content {
      type         = identity.value.type
      identity_ids = identity.value.user_assigned_resource_ids
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                           = each.value.name != null ? each.value.name : "diag-${var.name}"
  target_resource_id             = azapi_resource.this.id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_destination_type = each.value.log_analytics_destination_type
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

  dynamic "enabled_log" {
    for_each = each.value.log_categories

    content {
      category = enabled_log.value
    }
  }
  dynamic "enabled_log" {
    for_each = each.value.log_groups

    content {
      category_group = enabled_log.value
    }
  }
  dynamic "metric" {
    for_each = each.value.metric_categories

    content {
      category = metric.value
    }
  }
}
