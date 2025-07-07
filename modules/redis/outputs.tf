output "redis_primary_endpoint" {
  value = aws_elasticache_replication_group.example.primary_endpoint_address
  
}