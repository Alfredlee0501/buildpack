### Define Common variables #################################

variable "aws_region" {
  default     = null 
  type        = string
  description = "AWS region"
}


variable "resource_prefix" {
  default     = null
  type        = string
  description = "resource prefix"
}


### Define EKS variables ###################################
variable "cluster_name" {
  default     = "eks-cluster"
  type        = string
  description = "eks cluster name"
}

variable "cluster_node_name" {
  default     = "eks-node"
  type        = string
  description = "eks cluster node name"
}

variable "node_type" {
  default     = ["t3.xlarge"]
  type        = list(any)
  description = "eks cluster node type"
}

variable "node_desired_size" {
  default = 3
  type    = number
  description = "eks-node desired size"
}

variable "node_max_size" {
  default = 3 
  type    = number
  description = "eks- node maxize"
}

variable "node_min_size" {
  default = 3 
  type    = number
  description = "eks-node desired size"
}


## Define RDS variables ###################################
variable "postgres_version" {
  default     = "14.1"
  type        = string
  description = "PostgreSQL engine verion"
}

variable "postgres_storage" {
  default     = 10
  type        = number
  description = "PostgreSQL Allocated storage(GB)"
}

variable "postgres_port" {
  default     = 5432
  type        = number
  description = "PostgreSQL port"
}

variable "postgres_name" {
  default     = "KeycloakDb"
  type        = string
  description = "PostgreSQL name for servick application"
}

variable "postgres_instance_class" {
  default     = "db.t3.medium"
  type        = string
  description = "PostgreSQL instance size"
}

variable "postgres_master_user_name" {
  default     = "admin"
  type        = string
  description = "Maiadb master user name"
}


## Define Elasticache(redis) variables ###################################
variable "redis_port" {
  default     = 6379
  type        = number
  description = "Redis port"
}

variable "redis_node_type" {
  default     = "cache.t3.medium"
  type        = string
  description = "Redis node type"
}

