variable "name" {
  description = "(Required) Name of the repository"
  type        = string
}

variable "mutability" {
  description = "(Optional) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE."
  type        = string
  default     = "MUTABLE"
}