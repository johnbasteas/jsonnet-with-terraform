resource "aws_security_group" "alb_sg" {
  name        = var.sg_name
  description = var.sg_name
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_alb" "alb" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  ip_address_type    = var.ip_address_type
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.alb_sg.id]

  enable_deletion_protection = var.enable_deletion_protection

  tags = var.tags
}

resource "aws_security_group_rule" "alb_egress_all" {
  type      = "egress"
  from_port = 0
  to_port   = 65535
  protocol  = "TCP"

  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_alb_target_group" "alb_tg" {
  for_each             = { for k, v in try(var.target, {}) : k => v }
  name                 = each.key
  port                 = each.value.port
  protocol             = each.value.protocol
  vpc_id               = var.vpc_id
  deregistration_delay = 5
  target_type          = "ip"

  dynamic "health_check" {
    for_each = each.value.health_check
    content {
      path                = health_check.value.path
      interval            = health_check.value.interval
      matcher             = health_check.value.matcher
      unhealthy_threshold = health_check.value.unhealthy_threshold
    }
  }
  tags = var.tags
}

resource "aws_lb_listener" "http_alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_tg[keys(var.target)[0]].arn
  }
}

resource "aws_lb_listener_rule" "https_listener_rule" {
  for_each = { for k, v in local.target_rules : "${v.tgt_key}-${v.rule_key}" => v }

  priority     = each.value.priority
  listener_arn = aws_lb_listener.http_alb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_tg[each.value.tgt_key].arn
  }

  condition {
    path_pattern {
      values = each.value.path_pattern
    }
  }
}
