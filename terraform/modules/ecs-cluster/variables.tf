variable "cluster_name" {
  type = string
}

variable "insights" {
  type = string
}

variable "capacity_providers" {
  description = "List of capacity providers"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "default_capacity_provider" {
  description = "Default capacity provider settings"
  type = object({
    capacity_provider = string
    weight            = number
    base              = number
  })
  default = {
    capacity_provider = "FARGATE"
    weight            = 100
    base              = 50
  }
}

variable "tags" {
  description = "A map of tags to add to ECS Cluster resources"
  type        = map(string)
  default     = {}
}