local static = import '../common/static.libsonnet';

{
  global_environment_variables: {
    env: 'dev',
  },
  regional_environment_variables: {
    'eu-central-1': {
      regional_variable: 'some_value',
    },
    'eu-west-1': {},
  },
}
