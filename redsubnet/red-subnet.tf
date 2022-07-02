variable "vpcid" {
    type = string
}

resource "aws_subnet" "red_subnet" {
    vpc_id = var.vpcid
    cidr_block = "10.0.3.0/24"
    tags = {
        Name = "Red Subnet"
    }
}

resource "aws_security_group" "WS1" {
    vpc_id = var.vpcid
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

    user_data = file("${path.module}/../webserver1-startup.sh")

    tags = {
      Name = "WebServer1"
    }
}

resource "aws_eip" "webserver1_eip" {
    instance = aws_instance.webserver1.id
}

output "WebServer1-ID" {
    value = aws_instance.webserver1.id
}

output "WebServer1-ElasticIP" {
    value = aws_eip.webserver1_eip.public_ip
}
