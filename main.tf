terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.1"
    }
  }
  backend "s3" {
    bucket = "tf-backend-14-202403081122"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    #    dynamodb_table = "terraform-lock" # s3 bucket을 이용한 협업을 위해 설정 
  }
}
# # 기본적인 dynamodb_table 생성 설정
# resource "aws_dynamodb_table" "tf_backend_dynamodb_table" {
#   name         = "terraform-lock"
#   hash_key     = "LockID"
#   billing_mode = "PAY_PER_REQUEST"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

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

variable "envs" {
  type    = list(string)
  default = ["dev", "prd", ""]
}

module "personal_custom_vpc" {
  for_each = toset([for s in var.envs : s if s != ""]) # for_each문 안에 for문을 쓰고 리소스 for_each의 key값을 검증해서 공백이 아닌만큼 반복
  source   = "./custom_vpc"
  env      = "personal_${each.key}"
}

resource "aws_s3_bucket" "tf_backend" {
  bucket = "tf-backend-14-202403081122"
  # versioning {                   # deprecated된 문법으로 사용이 가능하긴 하나 권장하지 않음, 자체모듈에서 삭제시 업데이트 필요
  #   enabled = true
  # }
  tags = {
    Name = "tf_backend_14"
  }
}


resource "aws_s3_bucket_acl" "tf_backend_acl" {
  bucket = aws_s3_bucket.tf_backend.id
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "tf_backend_ownership" {
  bucket = aws_s3_bucket.tf_backend.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "tf_backend_versioning" {
  bucket = aws_s3_bucket.tf_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}
# 13.200.240.109
# 13.201.160.186
resource "aws_eip" "eip_test" {
  provisioner "local-exec" {
    command = "echo ${aws_eip.eip_test.public_ip}"
  }
  tags = {
    Name = "Test"
  }
}
