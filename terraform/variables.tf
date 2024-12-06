variable "aws" {
  description = "AWS Cloud parameters"
  type = object({
    tags = map(string)
  })
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "aws_resources" {
  description = "AWS Resources"
  type        = any
  default     = {}
}

variable "account_name" {
  type        = string
  description = "AWS Account Name"
}
