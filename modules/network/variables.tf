# modules/network/variables.tf

variable "env" {
  description = "Environment name (e.g., pre-prod or prod) for resource naming."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "List of Availability Zones to be used for subnets."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}