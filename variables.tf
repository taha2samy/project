
variable "aws_region" {
  description = "AWS region for the pre-prod environment."
  type        = string
}

variable "pre_prod_vpc_cidr" {
  description = "CIDR block for the pre-prod VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "pre_prod_public_subnet_cidrs" {
  description = "List of CIDR blocks for pre-prod public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24"] # Required: 1 public subnet for pre-prod
}

variable "pre_prod_instance_count" {
  description = "Number of EC2 instances for pre-prod."
  type        = number
  default     = 1 # Required: 1 t2.micro instance for pre-prod
}


variable "pre_prod_key_name" {
  description = "SSH Key Pair name for EC2 instances in pre-prod. This key must exist in your AWS account in the chosen region."
  type        = string
  default     = "your-ssh-key-name" # REPLACE WITH YOUR SSH KEY PAIR NAME
}