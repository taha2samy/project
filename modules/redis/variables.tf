variable "REDIS_PORT" {
  description = "Port for Redis in the pre-prod environment."
  type        = number
  default     = 6379 
  
}

variable "REDIS_PASSWORD" {
  description = "Password for Redis."
  type        = string
  sensitive = true
}
variable "node_type" {
  description = "The instance type for the Redis nodes."
  type        = string
  default     = "cache.t3.micro" # t2.micro does not support encryption
  
}
variable "redis_cluster_id" {
  description = "The ID of the Redis cluster."
  type        = string
  
}

variable "num_cache_clusters" {
    description = "Number of cache clusters in the Redis replication group."
    type        = number
    default     = 1
  
}
variable "subnet_group_name" {
  description = "The name of the subnet group for Redis."
  type        = string
  
}
variable "transit_encryption_enabled" {
    description = "Enable transit encryption for Redis."
    type        = bool
    default     = true
  
}

variable "env" {
  description = "The environment for the Redis instance."
  type        = string
  
}
variable "vpc_id" {
  description = "The VPC ID where the Redis instance will be deployed."
  type        = string
  
}