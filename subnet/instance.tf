resource "aws_instance" "webserver" {
    network_interface {
      network_interface_id = aws_network_interface.nic.id
      device_index = 0
    }

    ami = "ami-0a1ee2fb28fe05df3"
    instance_type = "t2.micro"
    key_name = "infstr-from-ntb"

    user_data = file("${path.module}/../${var.startup_script_name}")

    tags = {
      Name = var.instance_name
    }
}
