locals {
  target_rules = flatten([
    for tgt_key, tgt_val in try(var.target, {}) : [
      for rule_key, rule_val in try(tgt_val.rules, {}) : [
        {
          tgt_key      = tgt_key
          rule_key     = rule_key
          priority     = rule_val.priority
          path_pattern = rule_val.path_pattern
        }
      ]
      if length(try(rule_val.path_pattern, [])) > 0 && try(rule_val.priority, null) != null
    ]
  ])
}
