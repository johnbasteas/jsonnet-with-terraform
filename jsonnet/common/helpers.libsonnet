local static = import './static.libsonnet';

{
  getAccountName(env): static.account_name + '-' + env,

  getDefaultTags(env): {
    Owner: std.asciiUpper($.getAccountName(env)),
    Managed_by: std.asciiUpper('terraform'),
    Environment: std.asciiUpper(env),
  },
}
