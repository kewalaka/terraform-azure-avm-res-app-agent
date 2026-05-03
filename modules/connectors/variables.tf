variable "location" {
  type        = string
  description = <<DESCRIPTION
The location of the resource.
DESCRIPTION
}

variable "name" {
  type        = string
  description = <<DESCRIPTION
The name of the resource.
DESCRIPTION
}

variable "parent_id" {
  type        = string
  description = <<DESCRIPTION
The parent resource ID for this resource (the SRE Agent resource ID).
DESCRIPTION
}

variable "data_connector_type" {
  type        = string
  default     = null
  description = <<DESCRIPTION
The type of the data connector
DESCRIPTION
}

variable "data_source" {
  type        = string
  ephemeral   = true
  default     = null
  description = <<DESCRIPTION
Data source connection string or endpoint
DESCRIPTION
}

variable "data_source_version" {
  type        = number
  default     = null
  description = <<DESCRIPTION
Version tracker for data_source. Must be set when data_source is provided.
DESCRIPTION

  validation {
    condition     = var.data_source == null || var.data_source_version != null
    error_message = "When data_source is set, data_source_version must also be set."
  }
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module. For more information see https://aka.ms/avm/telemetryinfo.
DESCRIPTION
  nullable    = false
}

variable "endpoint" {
  type        = string
  default     = null
  description = <<DESCRIPTION
Endpoint of the connector
DESCRIPTION
}

variable "extended_properties" {
  type        = map(any)
  default     = null
  description = <<DESCRIPTION
Additional properties for the data connector which can be used to store custom key-value pairs
DESCRIPTION
}

variable "identity" {
  type        = string
  default     = null
  description = <<DESCRIPTION
Identity used to access the data source
DESCRIPTION
}
