output "agent_endpoint" {
  description = "The endpoint of the Agent"
  value       = try(azapi_resource.this.output.properties.agentEndpoint, null)
}

output "agent_identity_client_id" {
  description = "Client ID (GUID) for the agent identity"
  value       = try(azapi_resource.this.output.properties.agentIdentity.clientId, null)
}

output "agent_identity_enabled" {
  description = "Indicates whether the agent identity is enabled"
  value       = try(azapi_resource.this.output.properties.agentIdentity.enabled, null)
}

output "api_version" {
  description = "The resource api version"
  value       = try(azapi_resource.this.output.apiVersion, null)
}

output "identity_principal_id" {
  description = "The service principal ID of the system assigned identity."
  value       = try(azapi_resource.this.output.identity.principalId, null)
}

output "identity_tenant_id" {
  description = "The tenant ID of the system assigned identity."
  value       = try(azapi_resource.this.output.identity.tenantId, null)
}

output "name" {
  description = "The name of the created resource."
  value       = azapi_resource.this.name
}

output "resource" {
  description = "The full SRE Agent resource object."
  value       = azapi_resource.this
}

output "resource_id" {
  description = "The ID of the created resource."
  value       = azapi_resource.this.id
}

output "running_state" {
  description = "The running state of the Agent"
  value       = try(azapi_resource.this.output.properties.runningState, null)
}

output "system_data" {
  description = "Azure Resource Manager metadata containing createdBy and modifiedBy information."
  value       = try(azapi_resource.this.output.systemData, {})
}

output "type" {
  description = "The resource type"
  value       = try(azapi_resource.this.output.type, null)
}
