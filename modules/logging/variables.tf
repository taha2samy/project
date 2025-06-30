# modules/logging/variables.tf

variable "env" {
  description = "Environment name (must be 'prod') for resource naming."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC for which flow logs will be captured."
  type        = string
}