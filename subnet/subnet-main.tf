# Inputs

variable "vpcid" {
    type = string
}

variable "cidr" {
    type = string
}

variable "name" {
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

# Outputs

output "WebServer-ID" {
    value = aws_instance.webserver.id
}

output "WebServer-ElasticIP" {
    value = aws_eip.webserver_eip.public_ip
}
