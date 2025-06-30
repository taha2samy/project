
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "flow_logs_bucket" {
  bucket = "poc-${var.env}-flow-logs-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "poc-${var.env}-flow-logs-bucket"
    Env  = var.env
  }
}

resource "aws_s3_bucket_public_access_block" "flow_logs_bucket_public_access" {
  bucket = aws_s3_bucket.flow_logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "flow_logs_bucket_versioning" {
  bucket = aws_s3_bucket.flow_logs_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "allow_flow_logs_write" {
  bucket = aws_s3_bucket.flow_logs_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSLogDeliveryWrite"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.flow_logs_bucket.arn}/aws-logs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid    = "AWSLogDeliveryAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.flow_logs_bucket.arn
      }
    ]
  })
}


resource "aws_cloudwatch_log_group" "flow_logs_log_group" {
  name              = "/aws/vpc/flow-logs-poc-${var.env}"
  retention_in_days = 7

  tags = {
    Name = "poc-${var.env}-flow-logs-log-group"
    Env  = var.env
  }
}


resource "aws_iam_role" "flow_logs_role" {
  name = "poc-${var.env}-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "poc-${var.env}-flow-logs-role"
    Env  = var.env
  }
}

resource "aws_iam_role_policy" "flow_logs_policy" {
  name   = "poc-${var.env}-flow-logs-policy"
  role   = aws_iam_role.flow_logs_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*" 
      }
    ]
  })
}
resource "aws_flow_log" "s3_flow_log" {
  log_destination_type = "s3"
  log_destination      = aws_s3_bucket.flow_logs_bucket.arn
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id

  tags = {
    Name = "poc-${var.env}-s3-flow-log"
    Env  = var.env
  }
}

resource "aws_flow_log" "cloudwatch_flow_log" {
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.flow_logs_log_group.arn
  iam_role_arn         = aws_iam_role.flow_logs_role.arn
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id

  tags = {
    Name = "poc-${var.env}-cloudwatch-flow-log"
    Env  = var.env
  }
}