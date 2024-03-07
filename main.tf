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

# Create a VPC tags.name = "main"
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}
# Create a public subnet_1
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.10.0/24"

  tags = {
    Name = "public_subnet_1"
  }
}
# Create a public subnet_2
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.20.0/24"

  tags = {
    Name = "public_subnet_2"
  }
}
# Create a private subnet_1
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.110.0/24"

  tags = {
    Name = "private_subnet_1"
  }
}
# Create a private subnet_2
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.120.0/24"

  tags = {
    Name = "private_subnet_2"
  }
}
