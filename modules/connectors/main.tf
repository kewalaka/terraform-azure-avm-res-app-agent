resource "azapi_resource" "this" {
  type      = "Microsoft.App/agents/connectors@2026-01-01"
  name      = var.name
  parent_id = var.parent_id
  body      = local.resource_body
  sensitive_body = {
    properties = {
      dataSource = var.data_source
    }
  }
  sensitive_body_version = {
    "properties.dataSource" = var.data_source_version
  }
  response_export_values = [
    "apiVersion",
    "properties.deploymentError",
    "properties.source",
    "systemData",
    "type"
  ]
}
