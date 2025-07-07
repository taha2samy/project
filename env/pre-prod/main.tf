

resource "aws_db_subnet_group" "databe_subnet_group" {
  name       = "pre-prod-db-subnet-group"
  subnet_ids = module.pre_prod_network.public_subnet_ids
  description = "Subnet group for pre-prod database"
  
} 

resource "aws_elasticache_subnet_group" "redis" {
  name       = "redis-subnet-group"
  subnet_ids = module.pre_prod_network.public_subnet_ids 
}
module "redis" {
  source = "../../modules/redis"

  env                 = "pre-prod"
  vpc_id              = module.pre_prod_network.vpc_id
  subnet_group_name   = aws_elasticache_subnet_group.redis.name
  REDIS_PORT          = var.REDIS_PORT
  REDIS_PASSWORD      = var.REDIS_PASSWORD
  redis_cluster_id    = "redis-cluster"
  node_type           = "cache.t3.micro" # t2.micro does not support encryption
  transit_encryption_enabled = true
  num_cache_clusters = 1
  
}




module "db_instance" {
  source = "../../modules/db"
  env                 = "pre-prod"
  vpc_id              = module.pre_prod_network.vpc_id
  aws_db_subnet_group_names = aws_db_subnet_group.databe_subnet_group.name
  DB_NAME             = var.DB_NAME
  DB_USER             = var.DB_USER
  DB_PASSWORD         = var.DB_PASSWORD
  DB_PORT             = var.DB_PORT
  publicly_accessible = true
  skip_final_snapshot = true
  instance_class      = "db.t3.micro"
  allocated_storage   = 10
}


module "pre_prod_network" {
  source = "../../modules/network"

  env                = "pre-prod"
  vpc_cidr_block     = var.pre_prod_vpc_cidr
  public_subnet_cidrs = var.pre_prod_public_subnet_cidrs
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"] 
 
}


module "pre_prod_compute" {
  source = "../../modules/compute"

  env                 = "pre-prod"
  vpc_id              = module.pre_prod_network.vpc_id
  public_subnet_ids   = module.pre_prod_network.public_subnet_ids
  instance_count      = var.pre_prod_instance_count
  ami_id              = module.ami-amazon_linux.id
  key_name            = module.aws_key_pair
  instance_type       = "t2.micro" 
  user_data           = templatefile("${path.module}/../scripts/django.sh.tpl", {
    DB_NAME     = "${var.DB_NAME}",
    DB_USER     = "${var.DB_USER}",
    DB_PASSWORD = "${var.DB_PASSWORD}",
    DB_HOST     = "${module.db_instance.db_address}",
    REDIS_PASSWORD = var.REDIS_PASSWORD,
    REDIS_HOST = module.redis.redis_primary_endpoint,
    REDIS_PORT = var.REDIS_PORT
    
  })

}

