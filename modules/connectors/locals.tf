locals {
  resource_body = {
    name = var.name
    properties = {
      dataConnectorType  = var.data_connector_type
      endpoint           = var.endpoint
      extendedProperties = var.extended_properties == null ? null : { for k, value in var.extended_properties : k => value }
      identity           = var.identity
    }
  }
}
