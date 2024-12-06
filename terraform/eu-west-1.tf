module "euw1-vpc-complete" {
  for_each = { for k, v in try(var.aws_resources[local.euw1].vpc, {}) : k => v }
  source   = "terraform-aws-modules/vpc/aws"
  version  = "5.15.0"

  name = each.key
  cidr = each.value.cidr
  azs  = each.value.azs

  private_subnets     = each.value.private_subnets
  public_subnets      = each.value.public_subnets
  database_subnets    = each.value.database_subnets
  elasticache_subnets = each.value.elasticache_subnets

  enable_dns_hostnames = each.value.enable_dns_hostnames
  enable_dns_support   = each.value.enable_dns_support

  tags = local.tags
  providers = {
    aws = aws.euw1
  }
}

module "euw1-log_groups" {
  for_each          = local.euw1_log_groups
  source            = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version           = "4.3.0"
  name              = each.value.name
  retention_in_days = var.env == "prd" ? each.value.retention_in_days : 7
  tags              = local.tags
  providers = {
    aws = aws.euw1
  }
}

module "euw1-alb" {
  for_each = { for k, v in try(var.aws_resources[local.euw1].alb, {}) : k => v }
  source   = "./modules/alb"

  name     = each.key
  sg_name  = each.value.sg_name
  internal = each.value.internal

  ip_address_type = each.value.ip_address_type
  target          = each.value.target

  vpc_id     = module.euw1-vpc-complete[each.value.vpc].vpc_id
  subnet_ids = module.euw1-vpc-complete[each.value.vpc].public_subnets
  # certificate_arn = module.euw1-acm[each.value.certificate_domain_name].arn

  depends_on = [module.euw1-vpc-complete]
  tags       = local.tags
  providers = {
    aws = aws.euw1
  }
}

module "euw1-ecs-cluster" {
  for_each = { for k, v in try(var.aws_resources[local.euw1].ecs_cluster, {}) : k => v }
  source   = "./modules/ecs-cluster"

  cluster_name = each.key
  insights     = each.value.insights

  capacity_providers        = each.value.capacity_providers
  default_capacity_provider = each.value.default_capacity_provider

  tags = local.tags
  providers = {
    aws = aws.euw1
  }
}

module "euw1-ecs-service" {
  for_each = { for k, v in try(var.aws_resources[local.euw1].ecs_service, {}) : k => v }
  source   = "./modules/ecs-service"

  name               = each.key
  vpc_id             = module.euw1-vpc-complete[each.value.vpc].vpc_id
  alb_security_group = module.euw1-alb[each.value.alb].alb_security_group_id
  alb_target_group   = module.euw1-alb[each.value.alb].alb_target_group_arn[each.value.alb_target]
  ecs_cluster_arn    = module.euw1-ecs-cluster[each.value.ecs_cluster].ecs_cluster_arn

  use_alb_security_group      = each.value.use_alb_security_group
  enable_icmp_ingress         = each.value.enable_icmp_ingress
  ecs_security_group_name     = each.value.ecs_security_group_name
  ecs_sg_allow_container_port = each.value.ecs_sg_allow_container_port

  desired_count              = each.value.desired_count
  enable_execute_command     = each.value.enable_execute_command
  capacity_provider_strategy = each.value.capacity_provider_strategy

  enable_deployment_circuit_breaker          = each.value.enable_deployment_circuit_breaker
  enable_deployment_circuit_breaker_rollback = each.value.enable_deployment_circuit_breaker_rollback

  subnet_ids       = module.euw1-vpc-complete[each.value.vpc].public_subnets
  assign_public_ip = each.value.assign_public_ip

  task                    = each.value.task
  task_name               = each.value.task.name
  task_execution_role_arn = module.global-iam.iam_roles[each.value.task.exec_role].arn
  task_role_arn           = module.global-iam.iam_roles[each.value.task.role].arn

  task_cpu            = each.value.task.cpu
  task_memory         = each.value.task.memory
  task_log_group_name = each.value.task.log_group_name
  region              = local.euw1

  depends_on = [module.euw1-ecs-cluster, module.euw1-alb, module.euw1-vpc-complete, module.euw1-log_groups]

  tags = local.tags
  providers = {
    aws = aws.euw1
  }
}
