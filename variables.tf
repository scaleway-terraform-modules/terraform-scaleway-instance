variable "enable_ipv4" {
  description = "If set to True, server will have a public IPv4 address. Default to false."
  default     = false
}

variable "enable_ipv6" {
  description = "If set to True, server will be IPv6 enable. Default to false."
  default     = false
}

variable "image_name" {
  type        = "string"
  description = "Image ID. Defaut to Ubuntu Xenial arm"
  default     = "f71f2ad9-7810-405b-9181-2e8d5e1feb18"
#  default     = "b5a754d1-8262-47d2-acb2-22739295bb68" # Ubuntu Xenial x86_64
}

variable "server_name" {
  type        = "string"
  description = "Server name. Default to 'server'"
  default     = "server"
}

variable "server_type" {
  type        = "string"
  description = "Server type. Default to 'C1'"
  default     = "C1"
  #  default     = "DEV1-S"

}
