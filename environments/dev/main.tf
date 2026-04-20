module "networking" {
  source = "../../modules/networking"

  environment              = var.environment
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  web_subnet_cidrs         = var.web_subnet_cidrs
  application_subnet_cidrs = var.application_subnet_cidrs
}

module "iam" {
  source = "../../modules/iam"

  environment = var.environment
}

module "security_groups" {
  source = "../../modules/security_groups"

  environment = var.environment
  vpc_id      = module.networking.vpc_id
}

module "database" {
  source = "../../modules/database"

  environment             = var.environment
  db_username             = var.db_username
  db_password             = var.db_password
  db_name                 = var.db_name
  database_sg_id          = module.security_groups.database_sg_id
  db_subnet_group_name    = module.networking.db_subnet_group_name
  skip_final_snapshot     = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
}

module "load_balancing" {
  source = "../../modules/load_balancing"

  environment            = var.environment
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  application_subnet_ids = module.networking.application_subnet_ids
  alb_sg_id              = module.security_groups.alb_sg_id
  internal_alb_sg_id     = module.security_groups.internal_alb_sg_id
  deletion_protection    = var.deletion_protection
  certificate_arn        = var.certificate_arn
}

module "compute" {
  source = "../../modules/compute"

  environment              = var.environment
  aws_region               = var.aws_region
  ec2_ami                  = var.ec2_ami
  instance_type            = var.instance_type
  web_sg_id                = module.security_groups.web_sg_id
  app_sg_id                = module.security_groups.app_sg_id
  instance_profile_name    = module.iam.instance_profile_name
  internal_alb_dns         = module.load_balancing.internal_alb_dns_name
  db_address               = module.database.db_address
  db_name                  = var.db_name
  web_subnet_ids           = module.networking.web_subnet_ids
  application_subnet_ids   = module.networking.application_subnet_ids
  external_alb_tg_arn      = module.load_balancing.external_alb_tg_arn
  internal_alb_tg_arn      = module.load_balancing.internal_alb_tg_arn
  web_asg_min_size         = var.web_asg_min_size
  web_asg_max_size         = var.web_asg_max_size
  web_asg_desired_capacity = var.web_asg_desired_capacity
  app_asg_min_size         = var.app_asg_min_size
  app_asg_max_size         = var.app_asg_max_size
  app_asg_desired_capacity = var.app_asg_desired_capacity
}

module "monitoring" {
  source = "../../modules/monitoring"

  environment             = var.environment
  alert_email             = var.alert_email
  web_asg_name            = module.compute.web_asg_name
  app_asg_name            = module.compute.app_asg_name
  external_alb_arn_suffix = module.load_balancing.external_alb_arn_suffix
  db_instance_identifier  = module.database.db_instance_identifier
}

module "waf" {
  source = "../../modules/waf"

  environment      = var.environment
  external_alb_arn = module.load_balancing.external_alb_arn
}
