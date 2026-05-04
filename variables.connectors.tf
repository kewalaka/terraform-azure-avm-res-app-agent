variable "connectors" {
  type = map(object({
    data_connector_type = optional(string)
    data_source         = optional(string)
    data_source_version = optional(number)
    enable_telemetry    = optional(bool)
    endpoint            = optional(string)
    extended_properties = optional(map(any))
    identity            = optional(string)
    location            = string
    name                = string
  }))
  default     = {}
  description = <<DESCRIPTION
Map of instances for the connectors submodule with the following attributes:

**data_source**
Data source connection string or endpoint

**identity**
Identity used to access the data source

**data_source_version**
Version tracker for data_source. Must be set when data_source is provided.

**enable_telemetry**
This variable controls whether or not telemetry is enabled for the module. For more information see https://aka.ms/avm/telemetryinfo. Defaults to the root module's enable_telemetry value.

**data_connector_type**
The type of the data connector

**endpoint**
Endpoint of the connector

**extended_properties**
Additional properties for the data connector which can be used to store custom key-value pairs

**name**
The name of the resource.

**location**
The location of the resource.
DESCRIPTION
}
