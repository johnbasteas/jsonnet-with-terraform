resource "aws_ecs_cluster" "default" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = var.insights
  }

  tags = var.tags
}

resource "aws_ecs_cluster_capacity_providers" "default" {
  cluster_name = aws_ecs_cluster.default.name

  capacity_providers = var.capacity_providers

  default_capacity_provider_strategy {
    base              = var.default_capacity_provider.base
    weight            = var.default_capacity_provider.weight
    capacity_provider = var.default_capacity_provider.capacity_provider
  }
}