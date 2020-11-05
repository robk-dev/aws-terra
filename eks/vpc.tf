#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "rypock-dev" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terra-eks-rypock-dev-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_subnet" "rypock-dev" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.rypock-dev.id

  tags = map(
    "Name", "terra-eks-rypock-dev-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_internet_gateway" "rypock-dev" {
  vpc_id = aws_vpc.rypock-dev.id

  tags = {
    Name = "terra-eks-rypock-dev"
  }
}

resource "aws_route_table" "rypock-dev" {
  vpc_id = aws_vpc.rypock-dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rypock-dev.id
  }
}

resource "aws_route_table_association" "rypock-dev" {
  count = 2

  subnet_id      = aws_subnet.rypock-dev.*.id[count.index]
  route_table_id = aws_route_table.rypock-dev.id
}
