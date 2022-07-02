resource "aws_vpc" "challengevpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "challengevpc"
    }
}

resource "aws_internet_gateway" "challengeigw" {
    vpc_id = aws_vpc.challengevpc.id
    tags = {
      Name = "Challenge internet gateway"
    }
}

resource "aws_route" "challengeroutetogateway" {
    route_table_id = aws_vpc.challengevpc.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.challengeigw.id
}

output "vpcid" {
    value = aws_vpc.challengevpc.id
}