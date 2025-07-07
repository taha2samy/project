
variable "aws_region" {
  description = "AWS region for the pre-prod environment."
  type        = string
  default     = "eu-west-1" # Change to your desired region
}

variable "pre_prod_vpc_cidr" {
  description = "CIDR block for the pre-prod VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "pre_prod_public_subnet_cidrs" {
  description = "List of CIDR blocks for pre-prod public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24","10.0.2.0/24"] 
}

variable "pre_prod_instance_count" {
  description = "Number of EC2 instances for pre-prod."
  type        = number
  default     = 1 # Required: 1 t2.micro instance for pre-prod
}



variable "DB_NAME" {
  description = "Database name for the prod environment."
  type        = string
  default     = "pre_prod_db" # Required: Name of the database for prod
}
variable "DB_USER" {
  description = "Database user for the prod environment."
  type        = string
  default     = "pre_prod_user"
  
}

variable "DB_PASSWORD" {
  description = "Database password for the prod environment."
  type        = string
  default     = "pre_prod_password" # Required: Password for the database user
  
}
variable "DB_PORT" {
  description = "Database port for the prod environment."
  type        = number
  default     = 5432 
  
}
variable REDIS_PASSWORD {
  description = "Password for Redis in the pre-prod environment."
  type        = string
  default     = "pre_prod_redis_password" # Required: Password for Redis
}

variable "REDIS_PORT" {
  description = "Port for Redis in the pre-prod environment."
  type        = number
  default     = 6379 # Default Redis port
  
}