variable "vpcid" {
    type = string
}

resource "aws_subnet" "green_subnet" {
    vpc_id = var.vpcid
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

    user_data = file("${path.module}/../webserver2-startup.sh")

    tags = {
      Name = "WebServer2"
    }
}

resource "aws_security_group" "WS2" {
    vpc_id = var.vpcid
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

resource "aws_eip" "webserver2_eip" {
    instance = aws_instance.webserver2.id
}

output "WebServer2-ID" {
    value = aws_instance.webserver2.id
}

output "WebServer2-ElasticIP" {
    value = aws_eip.webserver2_eip.public_ip
}
