variable "name" {
  description = "(Required) The name of the DB"
  type        = string
}

variable "hash_key" {
  description = "(Required) The attribute to use as the hash (partition) key"
  type        = string
}

variable "range_key" {
  description = "The attribute to use as the range (sort) key."
  type        = string
  default     = null
}

variable "attributes" {
  description = "(Required) List of nested attribute definitions.  MUST include hash_key as well!"
  type = list(object({
    name = string
    type = string
  }))
}