locals {
  # AWS Regions
  use1 = "us-east-1"
  usw2 = "us-west-2"
  euc1 = "eu-central-1"
  euw1 = "eu-west-1"
  euw2 = "eu-west-2"

  # Tags
  tags = var.aws.tags

  # Cloudwatch Log groups
  use1_log_groups = try(var.aws_resources[local.use1].cloudwatch.log_groups, {})
  usw2_log_groups = try(var.aws_resources[local.usw2].cloudwatch.log_groups, {})
  euc1_log_groups = try(var.aws_resources[local.euc1].cloudwatch.log_groups, {})
  euw1_log_groups = try(var.aws_resources[local.euw1].cloudwatch.log_groups, {})
  euw2_log_groups = try(var.aws_resources[local.euw2].cloudwatch.log_groups, {})
}