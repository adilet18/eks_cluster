module "s3" {
  source      = "./s3"
  common_tags = var.common_tags
}

module "eks" {
  source      = "./eks"
  my_ip       = "158.181.157.142/32"
  common_tags = var.common_tags
}



module "rds" {
  source                  = "./rds"
  subnet_ids              = module.eks.public_subnet_ids
  vpc_id                  = module.eks.vpc_id
  private_subnet_cidrs_db = module.eks.private_subnet_ids
  common_tags             = var.common_tags
}


output "vpc_id" {
  value = module.eks.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.eks_name
}
output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "private_subnet_ids" {
  value = module.eks.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.eks.public_subnet_ids
}

output "s3_bucket_name" {
  value = module.s3.s3_bucket_name
}

output "dynamodb_table_name" {
  value = module.s3.dynamodb_table_name
}

output "vpc_cidr_block" {
  value = module.eks.vpc_cidr_block
}

output "web_public_dns" {
  value = module.rds.web_public_dns
}

output "database_port" {
  value = module.rds.database_port
}
