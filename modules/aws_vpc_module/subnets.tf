
locals {
  no_of_private_subnet = length(var.private_subnet_cidrs)
  no_of_public_subnet = length(var.public_subnet_cidrs)
}
resource "aws_subnet" "public_subnet" {
  count = local.no_of_public_subnet
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true


  tags = {
    Name = "PublicSubnet-${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = local.no_of_private_subnet
  vpc_id     = aws_vpc.main.id
  cidr_block =  element(var.private_subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "PrivateSubnet-${count.index}"
  }
}