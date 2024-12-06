locals {
  iam_policies = distinct(flatten([
    for k, v in var.iam.roles : [
      for policy in var.iam.roles[k].iam_policies : [
        {
          role   = k
          policy = policy
        }
      ] if var.iam.roles[k].iam_policies != []
    ] if can(var.iam.roles[k].iam_policies)
  ]))

  iam_aws_managed_policies = distinct(flatten([
    for k, v in var.iam.roles : [
      for arn in var.iam.roles[k].aws_managed : [
        {
          role       = k
          policy_arn = arn
          transformed_arn = replace(arn, "/[:/]/", "-")
        }
      ] if var.iam.roles[k].aws_managed != []
    ] if can(var.iam.roles[k].aws_managed)
  ]))

  tags = var.aws.tags
}
