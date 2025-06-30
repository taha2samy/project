variable "region" {
    description = "The AWS region to deploy resources in"
    default     = "eu-west-1"
  
}
variable "ec2_key" {
  
    description = "The EC2 key pair name to use for instances"
    type        = string
    default     = "tls_key_pair_ec2" 
    
}

variable "location_artifact" {
    description = "The S3 bucket location for storing artifacts"
    type        = string
    default     = "./"
  
}