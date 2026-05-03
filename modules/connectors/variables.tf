variable "name" {
  description = <<DESCRIPTION
The name of the resource.
DESCRIPTION
  type        = string
}

variable "parent_id" {
  description = <<DESCRIPTION
The parent resource ID for this resource (the SRE Agent resource ID).
DESCRIPTION
  type        = string
}

variable "location" {
  description = <<DESCRIPTION
The location of the resource.
DESCRIPTION
  type        = string
}

variable "data_connector_type" {
  description = <<DESCRIPTION
The type of the data connector
DESCRIPTION
  type        = string
  default     = null
}

variable "data_source" {
  description = <<DESCRIPTION
Data source connection string or endpoint
DESCRIPTION
  type        = string
  default     = null
  ephemeral   = true
}

variable "endpoint" {
  description = <<DESCRIPTION
Endpoint of the connector
DESCRIPTION
  type        = string
  default     = null
}

variable "extended_properties" {
  description = <<DESCRIPTION
Additional properties for the data connector which can be used to store custom key-value pairs
DESCRIPTION
  type        = map(any)
  default     = null
}

variable "identity" {
  description = <<DESCRIPTION
Identity used to access the data source
DESCRIPTION
  type        = string
  default     = null
}

variable "data_source_version" {
  description = <<DESCRIPTION
Version tracker for data_source. Must be set when data_source is provided.
DESCRIPTION
  type        = number
  default     = null
  validation {
    condition     = var.data_source == null || var.data_source_version != null
    error_message = "When data_source is set, data_source_version must also be set."
  }
}

variable "enable_telemetry" {
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module. For more information see https://aka.ms/avm/telemetryinfo.
DESCRIPTION
  type        = bool
  default     = true
  nullable    = false
}
