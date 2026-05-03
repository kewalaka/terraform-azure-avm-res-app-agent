resource "azapi_resource" "this" {
  location       = var.location
  name           = var.name
  parent_id      = var.parent_id
  type           = "Microsoft.App/agents/connectors@2026-01-01"
  body           = local.resource_body
  create_headers = var.enable_telemetry && var.avm_azapi_header != "" ? { "User-Agent" : var.avm_azapi_header } : null
  delete_headers = var.enable_telemetry && var.avm_azapi_header != "" ? { "User-Agent" : var.avm_azapi_header } : null
  read_headers   = var.enable_telemetry && var.avm_azapi_header != "" ? { "User-Agent" : var.avm_azapi_header } : null
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
  update_headers = var.enable_telemetry && var.avm_azapi_header != "" ? { "User-Agent" : var.avm_azapi_header } : null
}
