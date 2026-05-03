variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the this resource."

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{0,48}[a-zA-Z0-9]$", var.name))
    error_message = "The agent name must be between 2 and 50 characters, start and end with alphanumeric, and only contain alphanumeric characters and hyphens."
  }
}

variable "parent_id" {
  type        = string
  description = "The parent resource ID. For resource-group-scoped resources, pass the resource group ID from the caller (e.g., azurerm_resource_group.this.id)."
  nullable    = false
}

# SRE Agent specific variables
variable "action_configuration" {
  type = object({
    access_level = optional(any)
    identity     = optional(string)
    mode         = optional(any)
  })
  default     = null
  description = <<DESCRIPTION
Configuration for action

- `access_level` - The access level of the action
- `identity` - The identity used by the action
- `mode` - The mode of the action

DESCRIPTION
}

variable "agent_identity" {
  type = object({
    initial_sponsor_group_id = string
  })
  default     = null
  description = <<DESCRIPTION
Agent identity configuration for accessing resources

- `initial_sponsor_group_id` - Initial sponsor group ID (required for agent identity)

DESCRIPTION
}

variable "agent_space_id" {
  type        = string
  default     = null
  description = <<DESCRIPTION
The agent space ID referenced by the agent
DESCRIPTION
}

variable "connection_key" {
  type        = string
  ephemeral   = true
  default     = null
  description = <<DESCRIPTION
The key for the connection
DESCRIPTION
}

variable "connection_key_version" {
  type        = number
  default     = null
  description = <<DESCRIPTION
Version tracker for connection_key. Must be set when connection_key is provided.
DESCRIPTION

  validation {
    condition     = var.connection_key == null || var.connection_key_version != null
    error_message = "When connection_key is set, connection_key_version must also be set."
  }
}

variable "connection_string" {
  type        = string
  ephemeral   = true
  default     = null
  description = <<DESCRIPTION
The connection string for the Application Insights resource
DESCRIPTION
}

variable "connection_string_version" {
  type        = number
  default     = null
  description = <<DESCRIPTION
Version tracker for connection_string. Must be set when connection_string is provided.
DESCRIPTION

  validation {
    condition     = var.connection_string == null || var.connection_string_version != null
    error_message = "When connection_string is set, connection_string_version must also be set."
  }
}

variable "default_model" {
  type = object({
    name     = optional(string)
    provider = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
Default AI model configuration for the agent

- `name` - Model name (e.g., gpt-5, claude-opus-4-5, claude-sonnet-4-5)
- `provider` - AI provider name (e.g., MicrosoftFoundry, Anthropic)

DESCRIPTION
}

# required AVM interfaces
variable "diagnostic_settings" {
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
DESCRIPTION
  nullable    = false

  validation {
    condition     = alltrue([for _, v in var.diagnostic_settings : contains(["Dedicated", "AzureDiagnostics"], v.log_analytics_destination_type)])
    error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
  }
  validation {
    condition = alltrue(
      [
        for _, v in var.diagnostic_settings :
        v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
      ]
    )
    error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
  }
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "incident_management_configuration" {
  type = object({
    connection_key  = optional(string)
    connection_name = optional(string)
    connection_url  = optional(string)
    obo_user        = optional(string)
    type            = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
Incident management configurations

- `connection_key` - The key for the connection
- `connection_name` - The name of the connection
- `connection_url` - The URL of the connection
- `obo_user` - The user for the connection
- `type` - The type of incident management system

DESCRIPTION
}

variable "knowledge_graph_configuration" {
  type = object({
    identity          = optional(string)
    managed_resources = optional(list(string))
  })
  default     = null
  description = <<DESCRIPTION
Knowledge graph configuration for agent

- `identity` - The identity used to access the knowledge graph
- `managed_resources` - The list of resources managed by agent

DESCRIPTION
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

variable "log_configuration" {
  type = object({
    application_insights_configuration = optional(object({
      app_id            = optional(string)
      connection_string = optional(string)
    }))
  })
  default     = null
  description = <<DESCRIPTION
Log configurations

- `application_insights_configuration` - Application Insights Configuration
  - `app_id` - The Application ID for the Application Insights resource
  - `connection_string` - The connection string for the Application Insights resource

DESCRIPTION
}

# tflint-ignore: terraform_unused_declarations
variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = <<DESCRIPTION
Controls the Managed Identity configuration on this resource. The following properties can be specified:

- `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
- `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.
DESCRIPTION
  nullable    = false
}

variable "role_assignment_definition_lookup_enabled" {
  type        = bool
  default     = true
  description = "Whether to look up role definitions when creating role assignments (allows passing role definition names, not just IDs)."
  nullable    = false
}

variable "role_assignment_definition_scope" {
  type        = string
  default     = null
  description = "Scope to use for role-definition lookup when role assignments are configured. If unset, defaults to `parent_id`."
}

variable "role_assignments" {
  type = map(object({
    name                                   = optional(string, null)
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.
- `delegated_managed_identity_resource_id` - The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created.
- `principal_type` - The type of the principal_id. Possible values are `User`, `Group` and `ServicePrincipal`. Changing this forces a new resource to be created. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}

variable "upgrade_channel" {
  type        = any
  default     = null
  description = <<DESCRIPTION
The upgrade channel of the agent
DESCRIPTION
}
