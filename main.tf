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

module "main_vpc" {
  source = "./custom_vpc"
  env    = terraform.workspace
}

resource "aws_s3_bucket" "tf_backend" {
  count  = terraform.workspace == "default" ? 1 : 0 # workspace가 default일 때만 실행해라
  bucket = "tf-backend-14-202403081122"
  # versioning {                   # deprecated된 문법으로 사용이 가능하긴 하나 권장하지 않음, 자체모듈에서 삭제시 업데이트 필요
  #   enabled = true
  # }
  tags = {
    Name = "tf_backend_14"
  }
}


resource "aws_s3_bucket_acl" "tf_backend_acl" {
  count  = terraform.workspace == "default" ? 1 : 0 # workspace가 default일 때만 실행해라
  bucket = aws_s3_bucket.tf_backend[0].id
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "tf_backend_ownership" {
  count  = terraform.workspace == "default" ? 1 : 0 # workspace가 default일 때만 실행해라
  bucket = aws_s3_bucket.tf_backend[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "tf_backend_versioning" {
  count  = terraform.workspace == "default" ? 1 : 0 # workspace가 default일 때만 실행해라
  bucket = aws_s3_bucket.tf_backend[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_instance" "web-ec2" {
#   ami           = "ami-03bb6d83c60fc5f7c"
#   instance_type = "t2.micro"
#   key_name      = "HAN-14"
#   tags = {
#     Name = "my-14-web"
#   }
#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = file("HAN-14.pem")
#     host        = self.public_ip
#   }
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt update",
#       "sudo apt -y install nginx",
#       "sudo systemctl start nginx"
#     ]
#   }
#   provisioner "local-exec" {
#     command = "echo ${self.public_ip}"

#   }
# }
