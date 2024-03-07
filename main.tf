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
}

# 운영환경
module "prd_custom_vpc" {
  source = "./custom_vpc"
}
