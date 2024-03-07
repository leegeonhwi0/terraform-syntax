terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.1"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

# 개발환경
module "default_custom_vpc" {
  source = "./custom_vpc"
  env    = "dev"
}

# 운영환경
module "prd_custom_vpc" {
  source = "./custom_vpc"
  env    = "prd"
}

variable "names" {
  type    = list(string)
  default = ["ㅇㄱㄴ", "이건휘"]
}

module "personal_custom_vpc" {
  for_each = toset(var.names)
  source   = "./custom_vpc"
  env      = "personal_${each.key}"
}
