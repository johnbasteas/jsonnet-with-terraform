variable "tags" {
  description = "A map of tags to add to ALB resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Name of the ALB"
  type        = string
}

variable "sg_name" {
  description = "Security Group Name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "internal" {
  type    = bool
  default = false
}

variable "ip_address_type" {
  type    = string
  default = "ipv4"
}

variable "subnet_ids" {
  type = list(string)
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

# variable "certificate_arn" {
#   description = "Domain name of the certificate"
#   type        = string
# }

variable "target" {
  type = map(object({
    port     = number
    protocol = string
    health_check = list(object({
      path                = string
      interval            = number
      matcher             = string
      unhealthy_threshold = number
    }))
    rules = map(object({
      priority = number
      path_pattern = list(string)
    }))
  }))
  description = "Map of target groups with their configuration, including a list of health checks"
}
