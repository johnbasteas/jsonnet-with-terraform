local static = import '../common/static.libsonnet';

{
  global_environment_variables: {
    env: 'qa',
  },
  regional_environment_variables: {
    'eu-central-1': {},
    'eu-west-1': {},
  },
}
