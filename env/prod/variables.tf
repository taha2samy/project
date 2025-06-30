variable "aws_region" {
  description = "AWS region for the prod environment."
  type        = string
  default     = "us-east-1" # UPDATE_THIS: Adjust to your desired region (e.g., "eu-central-1")
}

variable "prod_vpc_cidr" {
  description = "CIDR block for the prod VPC."
  type        = string
  default     = "10.10.0.0/16" # Different CIDR to isolate from pre-prod
}

variable "prod_public_subnet_cidrs" {
  description = "List of CIDR blocks for prod public subnets."
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"] # Required: 2 public subnets for prod
}

variable "prod_instance_count" {
  description = "Number of EC2 instances for prod."
  type        = number
  default     = 3 
}



variable "prod_key_name" {
  description = "SSH Key Pair name for EC2 instances in prod. This key must exist in your AWS account in the chosen region."
  type        = string
  default     = "tls_key_pair_ec2_prod" # REPLACE_ME: Your SSH Key Pair name
}