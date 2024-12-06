{
  iam_role(role_name, assume_role_policy, iam_policies=[], aws_managed=[], role_path=null, role_force_detach_policies=true, role_permissions_boundary=null): {
    role_name: role_name,
    role_description: role_name + ' role',
    role_path: role_path,
    role_force_detach_policies: role_force_detach_policies,
    role_permissions_boundary: role_permissions_boundary,
    assume_role_policy: assume_role_policy,
    iam_policies: iam_policies,
    aws_managed: aws_managed,
  },
  iam_policy(name, policy): {
    name: name,
    policy: policy,
  },
}
