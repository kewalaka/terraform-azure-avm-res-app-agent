module "connectors" {
  source   = "./modules/connectors"
  for_each = var.connectors

  location            = each.value.location
  name                = each.value.name
  parent_id           = azapi_resource.this.id
  data_connector_type = each.value.data_connector_type
  data_source         = each.value.data_source
  data_source_version = each.value.data_source_version
  enable_telemetry    = each.value.enable_telemetry != null ? each.value.enable_telemetry : var.enable_telemetry
  endpoint            = each.value.endpoint
  extended_properties = each.value.extended_properties
  identity            = each.value.identity
}
