resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "IGW"
    application = var.application
    managed_by  = "terraform"

  }
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.name
    application = var.application
    managed_by  = "terraform"
  }
}

resource "aws_subnet" "this" {
  // Ptivate
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "private-subnet-1"
    application = var.application
    managed_by  = "terraform"
  }
}

resource "aws_subnet" "second" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name        = "private-subnet-2"
    application = var.application
    managed_by  = "terraform"
  }
}

resource "aws_subnet" "third" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name        = "private-subnet-3"
    application = var.application
    managed_by  = "terraform"
  }
}

resource "aws_subnet" "fourth" {
  // Will be used for bastion host
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "public"
    application = var.application
    managed_by  = "terraform"
  }
}

/** Not needed already defined in RDS module
resource "aws_db_subnet_group" "db-subnet" {
  name       = "oracle_rds_subnet_group"
  subnet_ids = [aws_subnet.second.id, aws_subnet.third.id]
}
**/

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "Public Route Table"
    application = var.application
    managed_by  = "terraform"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "public-route-table"
    Environment = "prod"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.fourth.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.this.id
  service_name = "com.amazonaws.us-west-2.s3"
  //service_name = "com.amazonaws.${var.zone}.s3"
}

resource "aws_vpc_endpoint_route_table_association" "s3_endpoint" {
  route_table_id = aws_route_table.private.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}