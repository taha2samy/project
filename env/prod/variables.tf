variable "aws_region" {
  description = "AWS region for the prod environment."
  type        = string
  default     = "eu-west-1"
}

variable "prod_vpc_cidr" {
  description = "CIDR block for the prod VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "prod_public_subnet_cidrs" {
  description = "List of CIDR blocks for prod public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "prod_instance_count" {
  description = "Number of EC2 instances for prod."
  type        = number
  default     = 1
}

variable "DB_NAME" {
  description = "Database name for the prod environment."
  type        = string
  default     = "prod_db"
}

variable "DB_USER" {
  description = "Database user for the prod environment."
  type        = string
  default     = "prod_user"
}

variable "DB_PASSWORD" {
  description = "Database password for the prod environment."
  type        = string
  default     = "prod_password"
}

variable "DB_PORT" {
  description = "Database port for the prod environment."
  type        = number
  default     = 5432
}

variable "REDIS_PASSWORD" {
  description = "Password for Redis in the prod environment."
  type        = string
  default     = "prod_redis_password"
}

variable "REDIS_PORT" {
  description = "Port for Redis in the prod environment."
  type        = number
  default     = 6379
}
