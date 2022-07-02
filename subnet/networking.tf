resource "aws_subnet" "subnet" {
    vpc_id = var.vpcid
    cidr_block = var.cidr
    tags = {
        Name = var.name
    }
}

resource "aws_eip" "webserver_eip" {
    instance = aws_instance.webserver.id
}

resource "aws_network_interface" "nic" {
    subnet_id = aws_subnet.subnet.id
    private_ips = [ var.instance_ip ]
    security_groups = [ aws_security_group.WS.id ]
    tags = {
        Name = var.instance_name
    }
}