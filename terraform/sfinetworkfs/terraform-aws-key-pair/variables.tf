variable "key_name" {
  description = "key_name"
  type        = string
  default     = null
}

variable "public_key" {
  description = "public_key"
  type        = string
}

variable "key_name_prefix" {
  description = " Creates a unique name beginning with the specified prefix. Conflicts with key_name. "
  type        = string
  default     = null
}

variable "tags" {
  description = "value"
  type        = map(string)
  default     = {}
}
