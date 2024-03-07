# Create a VPC tags.name = "main"
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}
# Create a public subnet_1
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "public_subnet"
  }
}
# Create a public subnet_2
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "public_subnet"
  }
}

# Create a NAT gateway
resource "aws_nat_gateway" "NAT_1" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.public_subnet.id
}

# Create a Internet gateway
resource "aws_internet_gateway" "IGW_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW_1"
  }
}
