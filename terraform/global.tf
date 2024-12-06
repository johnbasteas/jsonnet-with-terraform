################################################################################
# IAM
################################################################################
module "global-iam" {
  source = "./modules/aws-iam"
  iam    = var.aws_resources.global.iam
  env    = var.env
  aws    = var.aws
}
