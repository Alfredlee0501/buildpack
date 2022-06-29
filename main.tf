
module "vpc" {
  source          = "./vpc_module"
  resource_prefix = var.resource_prefix
  cluster_name    = var.cluster_name
}


module "eks" {
  source = "./eks_module"

  resource_prefix   = var.resource_prefix
  cluster_name      = var.cluster_name
  cluster_node_name = var.cluster_node_name
  node_type         = var.node_type
  node_desired_size = var.node_desired_size
  node_max_size     = var.node_max_size
  node_min_size     = var.node_min_size
  aws_region        = var.aws_region

  vpc_id     = module.vpc.vpc_id
  subnet_id1 = module.vpc.private_subnet_id[0]
  subnet_id2 = module.vpc.private_subnet_id[1]
}


module "data" {
  source          = "./data_module"
  resource_prefix = var.resource_prefix

  postgres_version          = var.postgres_version
  postgres_storage          = var.postgres_storage
  postgres_port             = var.postgres_port
  postgres_name             = var.postgres_name
  postgres_instance_class   = var.postgres_instance_class
  postgres_master_user_name = var.postgres_master_user_name
  redis_port               = var.redis_port
  redis_node_type          = var.redis_node_type

  vpc_id     = module.vpc.vpc_id
  subnet_id1 = module.vpc.private_subnet_id[0]
  subnet_id2 = module.vpc.private_subnet_id[1]
}

