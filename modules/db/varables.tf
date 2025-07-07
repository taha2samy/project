variable "DB_NAME" {
    type = string
  
}

variable "DB_USER" {
    type = string
  
}
variable "DB_PASSWORD" {
    type = string
  
}

variable "DB_PORT" {
    type = number
    default = 5432
}
  variable "publicly_accessible" {
    type    = bool
    default = true
  }

  variable "skip_final_snapshot" {
    type    = bool
    default = true
  }
variable "vpc_id" {
    type = string
  
}
variable "aws_db_subnet_group_names" {
  description = "The name of the DB subnet group"
  type        = string
}
variable "instance_class" {
  description = "The instance class for the database"
  type        = string
  default     = "db.t3.micro"
}
variable "allocated_storage" {
  description = "The allocated storage for the database in GB"
  type        = number
  default     = 5
}
variable "env" {
  description = "The environment for the database instance"
  type        = string
}