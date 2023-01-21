variable "image" {
  type        = string
  description = "UUID or the label of the base image used by the server."
}

variable "instance_type" {
  type        = string
  description = "Commercial type of the server. Default to 'DEV1-S'. Updates to this field will recreate a new resource."
  default     = "DEV1-S"
}

# Instance settings
variable "name" {
  type        = string
  description = "Name of the server."
  default     = null
}

variable "dns_zone" {
  type        = string
  description = "DNS Zone of the domain."
  default     = null
}

variable "placement_group_id" {
  type        = string
  description = "ID of the placement group the server is attached to."
  default     = null
}

variable "security_group_id" {
  type        = string
  description = "ID of the security group the server is attached to."
  default     = null
}

variable "tags" {
  type        = list(any)
  description = "Tags associated with the server and dedicated ip address."
  default     = []
}

# Storage
variable "additional_volume_ids" {
  type        = list(string)
  description = "Additional volumes attached to the server. Updates to this field will trigger a stop/start of the server."
  default     = []
}

# variable "root_volume" {
#   type    = any
#   default = null
# }

# Network

variable "enable_ipv6" {
  type        = bool
  description = "Determines if IPv6 is enabled for the server."
  default     = false
}

variable "enable_public_ipv4" {
  type        = bool
  description = "Determines if a public IPv4 will be attached to the server."
  default     = false
}

# variable "private_network" {
#   type    = string
#   description = "Private network associated with the server."
#   default = null
# }

# Start settings
variable "boot_type" {
  type        = string
  description = "The boot Type of the server. Default to 'local'. Possible values are: 'local', 'bootscript' or 'rescue'."
  default     = "local"

  validation {
    condition     = contains(["local", "bootscript", "rescue"], var.boot_type)
    error_message = "The image_id value must be one of 'local', 'bootscript' or 'rescue'."
  }
}

variable "bootscript_id" {
  type        = string
  description = "ID of the bootscript to use (set boot_type to bootscript)."
  default     = null
}

variable "state" {
  type        = string
  description = "State of the server. Default to 'started'. Possible values are: 'started', 'stopped' or 'standby'."
  default     = "started"

  validation {
    condition     = contains(["started", "stopped", "standby"], var.state)
    error_message = "The image_id value must be one of 'started', 'stopped' or 'standby'."
  }
}

# variable "user_data" {
#   type    = any
#   description = "User data associated with the server. Use the cloud-init key to use cloud-init on your instance. You can define values using:\n- string\n- UTF-8 encoded file content using file\n- Binary files using filebase64."
#   default = null
# }
