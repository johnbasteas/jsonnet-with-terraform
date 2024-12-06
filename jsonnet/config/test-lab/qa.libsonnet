local helpers = import '../../common/helpers.libsonnet';
local envs = import './envs/qaenv.libsonnet';
local static = import '../../common/static.libsonnet';
local common_data = import '../../common/commonData.libsonnet';

{
  account_name: static.account_name,
  env: envs.global_environment_variables.env,
  aws: {
    tags: helpers.getDefaultTags($.env),
  },
  aws_resources: {
    'eu-central-1': {
      vpc: common_data.vpc_config(static=static, aws_region='eu-central-1', cidr_block='10.1.0.0/20'),
    },
    'eu-west-1': {
      vpc: common_data.vpc_config(static=static, aws_region='eu-west-1', cidr_block='10.2.0.0/20'),
    },
  },
}
