variable "aws" {
  description = "AWS Cloud parameters"
  type = object({
    tags = map(string)
  })
}

variable "iam" {
  description = "IAM roles and policies from AWS Resources"
  type        = any
}

variable "env" {
  type        = string
  description = "Environment"
}
