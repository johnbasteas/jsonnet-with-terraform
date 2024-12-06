local specificConfig = {
  dev: import '../dev.libsonnet',
  qa: import '../qa.libsonnet',
};

local config(env) = specificConfig[env];

{
  [env + '.json']: config(env)
  for env in std.objectFields(specificConfig)
}
