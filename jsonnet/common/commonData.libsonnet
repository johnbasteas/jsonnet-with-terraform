// IAM Roles
local iam_role_data = import '../service-functions/iam/iam.libsonnet';
// IAM Role Policies
local assume_role_policy = import '../service-functions/iam/assume_role_policies/assume-role-policies.libsonnet';
// IAM policies
local ecs_task_policy = import '../service-functions/iam/policies/ecs-task-policy.libsonnet';
local ecs_task_exec_policy = import '../service-functions/iam/policies/ecs-task-exec-policy.libsonnet';
// VPC
local vpc_module = import '../service-functions/vpc/vpc.libsonnet';
// CLOUDWATCH
local cloudwatch_module = import '../service-functions/cloudwatch/cloudwatch.libsonnet';

{
  cloudwatch_config(retention_days): cloudwatch_module.cloudwatch_config(retention_days),

  iam(env): {
    roles: {
      'common-task-exec': iam_role_data.iam_role(
        role_name='common-task-exec',
        assume_role_policy=assume_role_policy.assume_role_policy('ecs-tasks.amazonaws.com'),
        iam_policies=[$.iam(env=env).policies.ecs_task_exec_policy.name],
      ),
      'test-lab-nginxservice-task': iam_role_data.iam_role(
        role_name='test-lab-nginxservice-task',
        assume_role_policy=assume_role_policy.assume_role_policy('ecs-tasks.amazonaws.com'),
        iam_policies=[$.iam(env=env).policies.ecs_task_policy.name],
        aws_managed=[
          'arn:aws:iam::aws:policy/AWSHealthFullAccess',
        ]
      ),
    },
    policies: {
      ecs_task_exec_policy: {
        name: 'ecs-task-exec-policy',
        policy: ecs_task_exec_policy.aws_iam_policy(),
      },
      ecs_task_policy: {
        name: 'ecs-task-policy',
        policy: ecs_task_policy.aws_iam_policy(),
      },
    },
  },

  vpc_config(
    static,
    aws_region,
    cidr_block
  ): vpc_module.vpc_config(
    static=static,
    aws_region=aws_region,
    cidr_block=cidr_block
  ),
}
