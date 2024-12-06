resource "aws_security_group" "ecs_service" {
  vpc_id      = var.vpc_id
  name        = var.ecs_security_group_name
  description = "Allow ALL egress from ECS service"
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.ecs_service.*.id)
}

resource "aws_security_group_rule" "allow_icmp_ingress" {
  count             = var.enable_icmp_ingress ? 1 : 0
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.ecs_service.*.id)
}

resource "aws_security_group_rule" "alb" {
  count                    = var.use_alb_security_group ? 1 : 0
  type                     = "ingress"
  from_port                = var.ecs_sg_allow_container_port
  to_port                  = var.ecs_sg_allow_container_port
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group
  security_group_id        = join("", aws_security_group.ecs_service.*.id)
}

resource "aws_ecs_task_definition" "default" {
  family                   = var.task_name
  container_definitions    = "[${jsonencode(local.container_definition)}]"
  requires_compatibilities = [var.task_launch_type]
  network_mode             = var.network_mode

  cpu                      = var.task_cpu
  memory                   = var.task_memory

  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn
}

resource "aws_ecs_service" "service" {
  name                               = var.name
  task_definition                    = aws_ecs_task_definition.default.arn
  desired_count                      = var.desired_count
  enable_execute_command             = var.enable_execute_command
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  launch_type                        = length(var.capacity_provider_strategy) == 0 ? "FARGATE" : null
  platform_version                   = var.platform_version
  force_new_deployment               = var.force_new_deployment
  # scheduling_strategy                = var.launch_type == "FARGATE" ? "REPLICA" : var.scheduling_strategy


  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategy
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = lookup(capacity_provider_strategy.value, "base", null)
    }
  }

  deployment_circuit_breaker {
    enable   = var.enable_deployment_circuit_breaker
    rollback = var.enable_deployment_circuit_breaker_rollback
  }

  load_balancer {
    target_group_arn = var.alb_target_group
    container_name   = var.task.container_name
    container_port   = var.task.container_port
  }

  cluster = var.ecs_cluster_arn

  deployment_controller {
    type = var.deployment_controller_type
  }

  # https://www.terraform.io/docs/providers/aws/r/ecs_service.html#network_configuration
  dynamic "network_configuration" {
    for_each = var.network_mode == "awsvpc" ? ["true"] : []
    content {
      security_groups  = [aws_security_group.ecs_service.id]
      subnets          = var.subnet_ids
      assign_public_ip = var.assign_public_ip
    }
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

locals {
  container_definition = {
    name              = var.task.container_name
    image             = var.container_image
    portMappings      = var.task_port_mappings
    healthCheck       = var.healthcheck
    logConfiguration  = {
      logDriver = "awslogs"
      options = {
        "awslogs-region"        = var.region
        "awslogs-group"         = var.task_log_group_name
        "awslogs-stream-prefix" = var.task_log_group_name
      }
      secretOptions = null
    }
    memory            = var.container_memory
    memoryReservation = var.container_memory_reservation
    cpu               = var.container_cpu
  }

  json_map = jsonencode(local.container_definition)
}