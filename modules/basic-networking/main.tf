/* VPC */
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = "${var.environment}"
  }
}

/* Internet Gateway */
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "${var.environment}-igw"
    Environment = "${var.environment}"
  }
}

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${element(aws_subnet.public_subnet_az1.*.id, 0)}"
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name        = "nat"
    Environment = "${var.environment}"
  }
}

/* Public Subnet */
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_subnets_cidr}"
  availability_zone       = "${var.availability_zones[0]}"
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.environment}-${var.availability_zones[0]}-      public-subnet"
    Environment = "${var.environment}"
  }
}

/* Private subnets */
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.private_subnets_cidr[0]}"
  availability_zone       = "${var.availability_zones[0]}"
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.environment}-${var.availability_zones[0]}-private-subnet"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.private_subnets_cidr[1]}"
  availability_zone       = "${var.availability_zones[1]}"
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.environment}-${var.availability_zones[1]}-private-subnet"
    Environment = "${var.environment}"
  }
}

/* Routing table for private subnets */
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}
/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

/* Routes */
resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}
resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}

/* Route Table Association */
resource "aws_route_table_association" "public_az1" {
  subnet_id      = "${aws_subnet.public_subnet_az1.id}"
  route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "private_az1" {
  subnet_id      = "${aws_subnet.private_subnet_az1.id}"
  route_table_id = "${aws_route_table.private.id}"
}
resource "aws_route_table_association" "private_az2" {
  subnet_id      = "${aws_subnet.private_subnet_az2.id}"
  route_table_id = "${aws_route_table.private.id}"
}


/* VPC's Default Security Group */
resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = "${aws_vpc.vpc.id}"
  depends_on  = [aws_vpc.vpc]
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }
  
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
  tags = {
    Environment = "${var.environment}"
  }
}