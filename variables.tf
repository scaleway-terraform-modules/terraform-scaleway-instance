variable "enable_ipv4" {
  type        = bool
  description = "If set to True, server will have a public IPv4 address. Default to false."
  default     = false
}

variable "enable_ipv6" {
  type        = bool
  description = "If set to True, server will be IPv6 enable. Default to false."
  default     = false
}

variable "image_name" {
  type        = string
  description = "Image ID. Defaut to Ubuntu Bionic Beaver x86_64"
  default     = "e640c621-305b-45f5-975f-a3f80c1cec66"
}

variable "server_name" {
  type        = string
  description = "Server name. Default to 'server'"
  default     = "server"
}

variable "server_state" {
  type        = string
  description = "Server state; either 'started', 'stopped' or 'standby'. Default to 'started'"
  default     = "started"
}

variable "server_type" {
  type        = string
  description = "Server type. Default to 'DEV1-S'"
  default     = "DEV1-S"
}

variable "server_tags" {
  type        = list
  description = "Server tags. Default to 'none"
  default     = []
}
