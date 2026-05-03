output "api_version" {
  description = "The resource api version"
  value       = try(azapi_resource.this.output.apiVersion, null)
}

output "deployment_error" {
  description = "Deployment error message if provisioning failed"
  value       = try(azapi_resource.this.output.properties.deploymentError, null)
}

output "name" {
  description = "The name of the created resource."
  value       = azapi_resource.this.name
}

output "resource_id" {
  description = "The ID of the created resource."
  value       = azapi_resource.this.id
}

output "source" {
  description = "Source of the data connector - \"Agent\" when directly stored in agent, \"AgentSpace\" when inherited"
  value       = try(azapi_resource.this.output.properties.source, null)
}

output "system_data" {
  description = "Azure Resource Manager metadata containing createdBy and modifiedBy information."
  value       = try(azapi_resource.this.output.systemData, {})
}

output "type" {
  description = "The resource type"
  value       = try(azapi_resource.this.output.type, null)
}
