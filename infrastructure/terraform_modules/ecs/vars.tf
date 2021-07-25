variable "app_name" {
  description = "(Required) The name of the app to be deployed"
  type        = string
}

variable "image" {
  description = "(Required) The ECR URL of the image to deploy"
  type        = string
}

variable "region" {
  description = "(Required) The AWS region"
  type        = string
}

variable "vpc" {
  description = "(Required) The VPC to build in"
  type        = string
}

variable "public_subnets" {
  description = "(Required) The public subnets of the vpc to use"
  type        = list(string)
}

variable "environment" {
  description = "Environment name, for tags"
  type        = string
  default     = null
}