



provider "aws" {
  region = var.region
}


resource "random_string" "prefix" {
  
  length  = 8
  special = false
  upper = false
}
resource "aws_s3_bucket" "backend_bucket" {
    
  bucket = "tf-state-${random_string.prefix.result}"
  
}
resource "aws_s3_bucket_public_access_block" "block_public_access" {
    bucket = aws_s3_bucket.backend_bucket.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
  
}
resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.backend_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
  
}
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
    bucket = aws_s3_bucket.backend_bucket.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
  
    depends_on = [aws_s3_bucket.backend_bucket]
}

resource "aws_dynamodb_table" "terraform_locks" {

  name         = "terraform-up-and-running-locks-${random_string.prefix.result}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"   
  }
}

resource "local_file" "backend_config" {
  filename = "${var.location_artifact}/backend-config.hcl"
  content  = <<EOT
bucket         = "${aws_s3_bucket.backend_bucket.id}"
region         = "${var.region}"
dynamodb_table = "${aws_dynamodb_table.terraform_locks.name}"
encrypt        = true
EOT
}

output "config_backend" {
    value = {
        bucket         = aws_s3_bucket.backend_bucket.id
        region         = var.region
        dynamodb_table = aws_dynamodb_table.terraform_locks.name
        encrypt        = true
    }
  
}

resource "tls_private_key" "name" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

resource "local_file" "private_key" {
  content  = tls_private_key.name.private_key_pem
  filename = "${var.location_artifact}/private_key.pem"
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.ec2_key
  public_key = tls_private_key.name.public_key_openssh
}
