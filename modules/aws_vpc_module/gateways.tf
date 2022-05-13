locals {
  no_of_nat_gateway =  length(var.private_subnet_cidrs) > 2 ? 3 :  length(var.private_subnet_cidrs)
}
resource "aws_nat_gateway" "nat_gateway" {
  count = local.no_of_nat_gateway
  allocation_id = element(aws_eip.eip[*].id, count.index)
  subnet_id     = element(aws_subnet.public_subnet[*].id, count.index)

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw_vpc]
}

resource "aws_internet_gateway" "igw_vpc" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_eip" "eip" {
  count = local.no_of_nat_gateway
  vpc      = true
   depends_on                = [aws_internet_gateway.igw_vpc]
}