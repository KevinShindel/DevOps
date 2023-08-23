#------------------------------
# Task: Create module block
# 
# Created by Kevin Shindel
#------------------------------
data "aws_availability_zones" "this" {}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.env}-igw"
  }
}
# ------------------- Public Subnets and Routing ------------------------

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.this.id
  count = length(var.public_subnet_cidrs)
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.this.names[count.index]
  map_public_ip_on_launch = true
    tags = {
    Name = "${var.env}-public-${count.index + 1}"
  }
}

resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
    tags = {
    Name = "${var.env}-route-public-subnets"
  }
}

resource "aws_route_table_association" "public_routes" {
  route_table_id = aws_route_table.public_subnets.id
  count = length(aws_subnet.public_subnets[*].id)
  subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
}

resource "aws_eip" "this" {
  count = length(var.private_subnet_cidrs)
  vpc = true
      tags = {
    Name = "${var.env}-net-gw-${count.index +1}"
  }
}

resource "aws_nat_gateway" "this" {
  count = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.this[count.index].id
  subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
        tags = {
    Name = "${var.env}-net-gw-${count.index +1}"
  }
}

# ------------------- Private Subnets and Routing ------------------------
resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.this.id
  cidr_block = element(var.private_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.this.names[count.index]
  map_public_ip_on_launch = true
    tags = {
    Name = "${var.env}-private-${count.index + 1}"
  }
}

resource "aws_route_table" "private_subnets" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this[count.index].id
  }
    tags = {
    Name = "${var.env}-route-private-subnets-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private_route" {
  count = length(aws_subnet.private_subnets[*].id)
  route_table_id = aws_route_table.private_subnets[count.index].id
  subnet_id = element(aws_subnet.private_subnets[*].id, count.index)
}