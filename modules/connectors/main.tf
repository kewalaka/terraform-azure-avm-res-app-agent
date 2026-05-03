resource "azapi_resource" "this" {
  name                      = var.name
  parent_id                 = var.parent_id
  type                      = "Microsoft.App/agents/connectors@2026-01-01"
  schema_validation_enabled = false
  body                      = local.resource_body
  response_export_values = [
    "apiVersion",
    "properties.deploymentError",
    "properties.source",
    "systemData",
    "type"
  ]
  sensitive_body = {
    properties = {
      dataSource = var.data_source
    }
  }
  sensitive_body_version = {
    "properties.dataSource" = var.data_source_version
  }
}
