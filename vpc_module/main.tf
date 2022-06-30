#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * NAT Gateway
#  * Route Table
#  * EIP
#

data "aws_availability_zones" "available" {}

resource "aws_vpc" "nexprime" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.resource_prefix}-buildpack-vpc",
  }
}


resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.nexprime.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true

  tags = tomap({
    Name                                                               = "${var.resource_prefix}-buildpack-public-subnet${count.index + 1}",
    "kubernetes.io/cluster/${var.resource_prefix}-${var.cluster_name}" = "shared",
  })
}


resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.nexprime.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.1${count.index}.0/24"
  map_public_ip_on_launch = false

  tags = tomap({
    Name = "${var.resource_prefix}-buildpack-private-subnet${count.index + 1}",
  })
}


resource "aws_internet_gateway" "nexprime" {
  vpc_id = aws_vpc.nexprime.id

  tags = {
    Name = "${var.resource_prefix}-buildpack-eks-ig"
  }
}

resource "aws_nat_gateway" "nexprime" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on    = [aws_internet_gateway.nexprime]

  tags = {
    Name = "${var.resource_prefix}-buildpack-nat-gw"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.nexprime.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nexprime.id
  }

  tags = {
    Name = "${var.resource_prefix}-buildpack-public-route"
  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.nexprime.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nexprime.id
  }

  tags = {
    Name = "${var.resource_prefix}-buildpack-private-route",
  }
}


resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private.id
}


resource "aws_eip" "nat" {
  vpc        = true
  depends_on = [aws_internet_gateway.nexprime]

  tags = {
    Name = "${var.resource_prefix}-buildpack-NAT"
  }
}


resource "aws_eip" "eip1" {
  vpc  = true
  tags = {
    Name = "${var.resource_prefix}-buildpack-EIP1"
  }
}


resource "aws_eip" "eip2" {
  vpc  = true
  tags = {
    Name = "${var.resource_prefix}-buildpack EIP2"
  }
}

