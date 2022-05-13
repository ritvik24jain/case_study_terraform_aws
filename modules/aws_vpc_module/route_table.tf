resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
   tags = {
    Name = "public route table"
  }
}
resource "aws_route_table" "private_route_table" {
  count = local.no_of_nat_gateway
  vpc_id = aws_vpc.main.id
   tags = {
    Name = "private route table"
  }
}
resource "aws_route_table_association" "private_association" {
  count = local.no_of_private_subnet
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = element(aws_route_table.private_route_table[*].id, count.index)
}
resource "aws_route_table_association" "public_association" {
  count = local.no_of_public_subnet
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw_vpc.id
  depends_on                = [aws_internet_gateway.igw_vpc]
}
resource "aws_route" "private_route" {
  count = local.no_of_nat_gateway
  route_table_id            = element(aws_route_table.private_route_table[*].id, count.index)
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = element(aws_nat_gateway.nat_gateway[*].id, count.index)
  depends_on                = [aws_nat_gateway.nat_gateway]
}