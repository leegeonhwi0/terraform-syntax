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

# # 개발환경
# module "default_custom_vpc" {
#   source = "./custom_vpc"
#   env    = "dev"
# }

# # 운영환경
# module "prd_custom_vpc" {
#   source = "./custom_vpc"
#   env    = "prd"
# }

variable "names" {
  type    = list(string)
  default = ["이거니", "이건휘"]
}

module "personal_custom_vpc" {
  for_each = toset([for s in var.names : "${s}_test"]) # for_each문 안에 for문을 써서 리소스 for_each의 key값 뒤에 _test를 붙임
  source   = "./custom_vpc"
  env      = "personal_${each.key}"
}
