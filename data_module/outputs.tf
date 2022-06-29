#
# Outputs
#

## RDS(PostgreSQL)
output "postgres_endpoint" {
  description = "The connection endpoint"
  value       = element(split(":", aws_db_instance.buildpack.endpoint),0)
}

output "postgres_user_name" {
  description = "The master username for the database"
  value       = aws_db_instance.buildpack.username
}

output "postgres_user_password" {
  description = "The master password for the database"
  value       = random_string.password.result
}


## Elasticache(Redis)
output "redis_cluster_endpoint" {
  description = "The elasticache_cluster connection endpoint url"
  value       = lookup(aws_elasticache_cluster.buildpack.cache_nodes[0],"address")
}
