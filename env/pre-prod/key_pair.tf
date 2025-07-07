module "key_pair" {
  source    = "../modules/key-pair"
  key_name  = "pre_prod_ec2_key"
  key_path  = "${path.module}/pre_prod_ec2_key.pem"
  rsa_bits  = 2048
  
}