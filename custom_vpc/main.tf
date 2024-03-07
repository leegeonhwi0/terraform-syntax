# Create a VPC tags.name = "main"
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "hangaramit_vpc_${var.env}"
  }
}
# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = local.az_a

  tags = {
    Name = "public_subnet_1_${var.env}"
  }
}
# Create a private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = local.az_a

  tags = {
    Name = "private_subnet_1_${var.env}"
  }
}

# Create a NAT gateway
resource "aws_nat_gateway" "NAT_1" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.public_subnet.id
  tags = {
    Name = "hangaramit_NAT_1_${var.env}"
  }
}

# Create a Internet gateway
resource "aws_internet_gateway" "IGW_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "hangaramit_IGW_1_${var.env}"
  }
}
