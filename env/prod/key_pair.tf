module "key_pair" {
  source    = "../../modules/key-pair"
  key_name  = "pre_prod_ec2_key.pem"
  key_path  = "${path.root}/pre_prod_ec2_key.pem"
  rsa_bits  = 2048
  
}