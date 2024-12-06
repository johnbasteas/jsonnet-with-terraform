output "alb_arn" {
  value = aws_alb.alb.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_dns_name" {
  value = aws_alb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_alb.alb.zone_id
}

output "alb_target_group_arn" {
  value = { for k, v in var.target : k => aws_alb_target_group.alb_tg[k].arn }
}