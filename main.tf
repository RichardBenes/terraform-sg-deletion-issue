provider "aws" {
    region = "eu-central-1"
}

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

resource "aws_subnet" "red_subnet" {
    vpc_id = aws_vpc.challengevpc.id
    cidr_block = "10.0.3.0/24"
    tags = {
        Name = "Red Subnet"
    }
}

resource "aws_network_interface" "nic_ws1" {
    subnet_id = aws_subnet.red_subnet.id
    private_ips = [ "10.0.3.10" ]
    security_groups = [ aws_security_group.WS1.id ]
    tags = {
      Name = "nic_ws1"
    }
}

resource "aws_instance" "webserver1" {
    network_interface {
      network_interface_id = aws_network_interface.nic_ws1.id
      device_index = 0
    }

    ami = "ami-0a1ee2fb28fe05df3"
    instance_type = "t2.micro"
    key_name = "infstr-from-ntb"

    user_data = file("${path.module}/webserver1-startup.sh")

    tags = {
      Name = "WebServer1"
    }
}

output "WebServer1-ID" {
    value = aws_instance.webserver1.id
}

resource "aws_eip" "webserver1_eip" {
    instance = aws_instance.webserver1.id
}
output "WebServer1-ElasticIP" {
    value = aws_eip.webserver1_eip.public_ip
}

resource "aws_security_group" "WS1" {
    vpc_id = aws_vpc.challengevpc.id
    name = "WS1"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 65535
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_subnet" "green_subnet" {
    vpc_id = aws_vpc.challengevpc.id
    cidr_block = "10.0.4.0/24"
    tags = {
        Name = "Green Subnet"
    }
}

resource "aws_network_interface" "nic_ws2" {
    subnet_id = aws_subnet.green_subnet.id
    private_ips = [ "10.0.4.20" ]
    security_groups = [ aws_security_group.WS2.id ]
    tags = {
        Name = "nic_ws2"
    }
}

resource "aws_instance" "webserver2" {
    network_interface {
      network_interface_id = aws_network_interface.nic_ws2.id
      device_index = 0
    }

    ami = "ami-0a1ee2fb28fe05df3"
    instance_type = "t2.micro"
    key_name = "infstr-from-ntb"

    user_data = file("${path.module}/webserver2-startup.sh")
    
    tags = {
      Name = "WebServer2"
    }
}

resource "aws_security_group" "WS2" {
    vpc_id = aws_vpc.challengevpc.id
    name = "WS2"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 65535
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "WebServer2-ID" {
    value = aws_instance.webserver2.id
}

resource "aws_eip" "webserver2_eip" {
    instance = aws_instance.webserver2.id
}
output "WebServer2-ElasticIP" {
    value = aws_eip.webserver2_eip.public_ip
}
