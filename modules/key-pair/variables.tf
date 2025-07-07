variable "key_name" {
  description = "The name of the key pair"
  type        = string
}
variable "key_path" {
  description = "The path to the private key file"
  type        = string
  default     = "${path.module}/pre_pod_ec2_key.pem"
}

variable "rsa_bits" {
  description = "The number of bits in the RSA key"
  type        = number
  default     = 2048
}