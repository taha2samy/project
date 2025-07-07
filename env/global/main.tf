

provider "aws" {
  region = var.region
}

resource "random_string" "Prefix" {
  length  = 10
  special = false
  upper   = false
  lower   = true
  numeric = false
}
resource "aws_s3_bucket" "backend_bucket" {
    
  bucket = "${random_string.Prefix.result}-backend-bucket"
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

  name         = "${random_string.Prefix.result}-dynamodb-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"   
  }
}

resource "local_file" "backend_config" {
  filename = "${path.module}/../backend-config.hcl"
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

