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
