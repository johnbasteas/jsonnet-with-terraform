variable "tags" {
  description = "A map of tags to add to ALB resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  type = string
}

variable "alb_security_group" {
  type    = string
  default = ""
}

variable "alb_target_group" {
  type    = string
  default = ""
}

variable "ecs_cluster_arn" {
  type = string
}

variable "use_alb_security_group" {
  type    = bool
  default = false
}

variable "enable_icmp_ingress" {
  description = "Enable ICMP Ingress Rule"
  type        = bool
  default     = false
}

variable "ecs_security_group_name" {
  type    = string
  default = ""
}

variable "ecs_sg_allow_container_port" {
  type    = number
  default = 80
}

variable "name" {
  type = string
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "enable_execute_command" {
  type    = bool
  default = false
}

variable "deployment_maximum_percent" {
  type    = number
  default = 200
}

variable "deployment_minimum_healthy_percent" {
  type    = number
  default = 100
}

variable "capacity_provider_strategy" {
  description = "List of capacity provider strategies"
  type = list(object({
    capacity_provider = string
    base              = number
    weight            = number
  }))
  default = []
}

variable "platform_version" {
  type    = string
  default = "LATEST"
}

variable "force_new_deployment" {
  type    = bool
  default = false
}

variable "enable_deployment_circuit_breaker" {
  default = "false"
  type    = bool
}

variable "enable_deployment_circuit_breaker_rollback" {
  default = "false"
  type    = bool
}

variable "task" {
  description = "Configuration for a specific task"
  type = object({
    container_name = string
    container_port = number
  })
  default = {
    container_name = "nginx"
    container_port = 80
  }
}

variable "deployment_controller_type" {
  type    = string
  default = "ECS"
}

variable "network_mode" {
  type    = string
  default = "awsvpc"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "assign_public_ip" {
  type        = bool
  default     = false
  description = "Assign a public IP address to the ENI (Fargate launch type only). Valid values are `true` or `false`. Default `false`"
}

variable "task_name" {
  type    = string
}

variable "task_execution_role_arn" {
  type    = string
}

variable "task_role_arn" {
  type    = string
}

variable "task_port_mappings" {
  description = "List of port mappings for the container"
  type = list(object({
    containerPort = number
    hostPort      = number
    protocol      = string
  }))
  default = [
    {
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }
  ]
}

variable "task_cpu" {
  type    = number
  default = 1024
}

variable "task_memory" {
  type    = number
  default = 2048
}

variable "task_launch_type" {
  type    = string
  default = "FARGATE"
}

variable "container_memory" {
  type    = number
  default = 2048
}

variable "container_memory_reservation" {
  type    = number
  default = 2048
}

variable "container_cpu" {
  type    = number
  default = 1024
}

variable "container_image" {
  type    = string
  default = "nginx"
}

variable "healthcheck" {
  type = object({
    command     = list(string)
    retries     = number
    timeout     = number
    interval    = number
    startPeriod = number
  })
  default = null
}

variable "task_log_group_name" {
  type    = string
}

variable "region" {
  type    = string
}
