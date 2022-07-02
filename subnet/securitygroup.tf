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
