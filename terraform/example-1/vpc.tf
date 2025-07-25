# --------------------
# Networking
# --------------------
resource "aws_vpc" "ecs_vpc" {
  cidr_block = var.vpc_cidr_block
  # enable_dns_hostnames = true # Does not exist in any of the gpt examples
  # enable_dns_support   = true # Does not exist in any of the gpt examples

  tags = {
    name        = "${var.project_name}-vpc"
    environment = var.environment
  }
}

# Create a public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.ecs_vpc.cidr_block, 8, 1)
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    name = "${var.project_name}-public-subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    name = "${var.project_name}-igw"
  }
}

# Route table and association
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# EXTRA SUBNET!!! THIS IS ONLY REQUIRED FOR EXAMPLE 1 AND GPT-3

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.ecs_vpc.cidr_block, 8, 2)
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true

  tags = {
    name = "${var.project_name}-public-subnet-b"
  }
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}