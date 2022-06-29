#
# Data Store
#  * RDS (PostgreSQL 14.1-R1)
#  * Elasticache (Redis 6.x)
#


## RDS(PostgreSQL)  #####################################################
resource "random_string" "password" {
  length  = 10
  special = false
}


resource "aws_db_subnet_group" "buildpack" {
  name        = "${var.resource_prefix}-buildpack-rds-subnet-group"
  description = "BuildPack RDS subnet group"
  subnet_ids  = [var.subnet_id1, var.subnet_id2]

  tags = {
    Name = "aws db subnet group via buildpack"
  }
}


resource "aws_db_instance" "buildpack" {
  identifier             = "${var.resource_prefix}-buildpackdb"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = var.postgres_version
  instance_class         = var.postgres_instance_class
  db_name                = var.postgres_name
  username               = var.postgres_master_user_name
  password               = random_string.password.result
  skip_final_snapshot    = true
  apply_immediately      = true
  vpc_security_group_ids = ["${aws_security_group.buildpack.id}"]
  db_subnet_group_name   = aws_db_subnet_group.buildpack.id
  parameter_group_name   = aws_db_parameter_group.buildpack.name
}


resource "aws_db_parameter_group" "buildpack" {
  name   = "${var.resource_prefix}buildpackparameter"
  family = "postgres14.1"

  parameter {
    name  = "max_connections"
    value = "1000"
  }
}


resource "aws_security_group" "buildpack" {
  name        = "${var.resource_prefix}-buildpack_rds_sg"
  description = "BuildPack RDS PostgreSQL sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.postgres_port
    to_port     = var.postgres_port
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
}


## Elasticache(redis) ##################################
resource "aws_elasticache_cluster" "buildpack" {
  cluster_id           = "${var.resource_prefix}-redis-cluster"
  engine               = "redis"
  node_type            = var.redis_node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  apply_immediately    = true
  security_group_ids   = ["${aws_security_group.redis_sg.id}"]
  subnet_group_name    = aws_elasticache_subnet_group.buildpack.id
}


resource "aws_elasticache_subnet_group" "buildpack" {
  name       = "${var.resource_prefix}-redis-subnet-group"
  subnet_ids = [var.subnet_id1, var.subnet_id2]
}


resource "aws_security_group" "redis_sg" {
  name   = "${var.resource_prefix}-redis-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.redis_port
    to_port     = var.redis_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}


