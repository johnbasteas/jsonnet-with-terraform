terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "<= 5.75.1"
    }
  }

  # backend "s3" {
  #   encrypt = true
  # }
}

provider "aws" {
  alias  = "euc1"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "euw2"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "euw1"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "usw2"
  region = "us-west-2"
}
