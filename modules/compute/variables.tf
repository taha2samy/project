# modules/compute/variables.tf

variable "env" {
  description = "Environment name (e.g., pre-prod or prod) for resource naming."
  type        = string
}
variable "user_data" {
  description = "User data script to run on instance launch (e.g., for initial setup)."
  type        = string
  
}
variable "vpc_id" {
  description = "The ID of the VPC where EC2 instances will be launched."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs to launch EC2 instances into."
  type        = list(string)
}

variable "instance_count" {
  description = "Number of EC2 instances to provision."
  type        = number
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instances (e.g., Amazon Linux 2)."
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type (must be t2.micro for Free Tier)."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the SSH Key Pair for EC2 instance access."
  type        = string
}