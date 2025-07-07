resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = var.rsa_bits

}
resource "local_file" "privatekey" {
  filename         = var.key_path
  content          = tls_private_key.ec2_key.private_key_pem
  file_permission  = "0400"
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "{var.key_name}"
  public_key = tls_private_key.ec2_key.public_key_openssh

}
