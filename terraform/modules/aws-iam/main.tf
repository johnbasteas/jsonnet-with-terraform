resource "aws_iam_role" "role" {
  for_each = try(var.iam.roles, {})

  name                  = each.key
  description           = each.value.role_description
  path                  = each.value.role_path
  force_detach_policies = each.value.role_force_detach_policies
  permissions_boundary  = each.value.role_permissions_boundary
  assume_role_policy    = jsonencode(each.value.assume_role_policy)
  tags                  = local.tags
}

resource "aws_iam_policy" "policy" {
  for_each = { for k, v in var.iam.policies : v.name => v }
  name     = each.value.name
  policy   = jsonencode(each.value.policy)
}
resource "aws_iam_role_policy_attachment" "attachment" {
  for_each   = { for k, v in local.iam_policies : "${v.role}-${v.policy}" => v }
  role       = aws_iam_role.role[each.value.role].name
  policy_arn = aws_iam_policy.policy[each.value.policy].arn
}

resource "aws_iam_role_policy_attachment" "aws_managed" {
  for_each   = { for k, v in local.iam_aws_managed_policies : "${v.role}-${v.transformed_arn}" => v }
  role       = aws_iam_role.role[each.value.role].name
  policy_arn = each.value.policy_arn
}
