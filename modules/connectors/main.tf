resource "azapi_resource" "this" {
  name      = var.name
  parent_id = var.parent_id
  type      = "Microsoft.App/agents/connectors@2026-01-01"
  body      = local.resource_body
  response_export_values = [
    "apiVersion",
    "properties.deploymentError",
    "properties.source",
    "systemData",
    "type"
  ]
  schema_validation_enabled = false
  sensitive_body = {
    properties = {
      dataSource = var.data_source
    }
  }
  sensitive_body_version = {
    "properties.dataSource" = var.data_source_version
  }
}
