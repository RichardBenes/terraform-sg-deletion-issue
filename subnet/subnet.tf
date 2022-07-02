variable "vpcid" {
    type = string
}

variable "cidr" {
    type = string
}

variable "subnet_name" {
    type = string
}

variable "instance_ip" {
    type = string
}

variable "instance_name" {
    type = string
}

variable "startup_script_name" {
    type = string
}

resource "aws_subnet" "subnet" {
    vpc_id = var.vpcid
    cidr_block = var.cidr
    tags = {
        Name = var.subnet_name
    }
}

resource "aws_security_group" "WS" {
    vpc_id = var.vpcid
    name = "WS"

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

resource "aws_network_interface" "nic" {
    subnet_id = aws_subnet.subnet.id
    private_ips = [ var.instance_ip ]
    security_groups = [ aws_security_group.WS2.id ]
    tags = {
        Name = var.instance_name
    }
}

resource "aws_instance" "webserver2" {
    network_interface {
      network_interface_id = aws_network_interface.nic.id
      device_index = 0
    }

    ami = "ami-0a1ee2fb28fe05df3"
    instance_type = "t2.micro"
    key_name = "infstr-from-ntb"

    user_data = file("${path.module}/../${startup_script_name}")

    tags = {
      Name = var.instance_name
    }
}



resource "aws_eip" "webserver2_eip" {
    instance = aws_instance.webserver2.id
}

output "WebServer1-ID" {
    value = aws_instance.webserver1.id
}

output "WebServer1-ElasticIP" {
    value = aws_eip.webserver1_eip.public_ip
}
