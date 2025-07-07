resource "aws_elasticache_replication_group" "example" {
  replication_group_id       = var.redis_cluster_id
  description                = "Redis cluster with encryption and auth"
  node_type                  = var.node_type # t2.micro does not support encryption
  num_cache_clusters         = var.num_cache_clusters
  port                       = var.REDIS_PORT
  subnet_group_name          = var.subnet_group_name
  security_group_ids         = [aws_security_group.redis.id] # You must provide a security group ID
  
  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.REDIS_PASSWORD
  tags = {
    Name = "${var.env}-redis-cluster"
    Env  = var.env
  }
}
resource "aws_security_group" "redis" {
  
  name        = "redis-security-group"
  description = "Security group for Redis"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.REDIS_PORT
    to_port     = var.REDIS_PORT
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}