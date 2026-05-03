locals {
  managed_identities = {
    system_assigned_user_assigned = (var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0) ? {
      this = {
        type                       = var.managed_identities.system_assigned && length(var.managed_identities.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(var.managed_identities.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
    system_assigned = var.managed_identities.system_assigned ? {
      this = {
        type = "SystemAssigned"
      }
    } : {}
    user_assigned = length(var.managed_identities.user_assigned_resource_ids) > 0 ? {
      this = {
        type                       = "UserAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
  }
  parent_id = data.azurerm_resource_group.parent.id
  resource_body = {
    name = var.name
    properties = {
      actionConfiguration = var.action_configuration == null ? null : {
        accessLevel = var.action_configuration.access_level
        identity    = var.action_configuration.identity
        mode        = var.action_configuration.mode
      }
      agentIdentity = var.agent_identity == null ? null : {
        initialSponsorGroupId = var.agent_identity.initial_sponsor_group_id
      }
      agentSpaceId = var.agent_space_id
      defaultModel = var.default_model == null ? null : {
        name     = var.default_model.name
        provider = var.default_model.provider
      }
      incidentManagementConfiguration = var.incident_management_configuration == null ? null : {
        connectionName = var.incident_management_configuration.connection_name
        connectionUrl  = var.incident_management_configuration.connection_url
        oboUser        = var.incident_management_configuration.obo_user
        type           = var.incident_management_configuration.type
      }
      knowledgeGraphConfiguration = var.knowledge_graph_configuration == null ? null : {
        identity         = var.knowledge_graph_configuration.identity
        managedResources = var.knowledge_graph_configuration.managed_resources == null ? null : [for item in var.knowledge_graph_configuration.managed_resources : item]
      }
      logConfiguration = var.log_configuration == null ? null : {
        applicationInsightsConfiguration = var.log_configuration.application_insights_configuration == null ? null : {
          appId = var.log_configuration.application_insights_configuration.app_id
        }
      }
      upgradeChannel = var.upgrade_channel
    }
    tags = var.tags == null ? null : { for k, value in var.tags : k => value }
  }
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
}
