provider "aws" {
    region = "eu-central-1"
}

module "vpccreator" {
    source = "./vpc"
}

module "red_subnet" {
    source = "./redsubnet"
    vpcid = module.vpccreator.vpcid
}

module "green_subnet" {
    source = "./greensubnet"
    vpcid = module.vpccreator.vpcid
}

module "blue_subnet" {
    source = "./subnet"
    vpcid = module.vpccreator.vpcid
    cidr = "10.0.5.0/24"
    name = "Blue Subnet"
    instance_ip = "10.0.5.30"
    instance_name = "WebServerInBlue"
    startup_script_name = "webserver3-startup.sh"
}

output "WebServer1-ID" {
    value = module.red_subnet.WebServer1-ID
}
output "WebServer1-ElasticIP" {
    value = module.red_subnet.WebServer1-ElasticIP
}

output "WebServer2-ID" {
    value = module.green_subnet.WebServer2-ID
}
output "WebServer2-ElasticIP" {
    value = module.green_subnet.WebServer2-ElasticIP
}

output "WebServerInBlue-ID" {
    value = module.blue_subnet.WebServer-ID
}
output "WebServerInBlue-ElasticIP" {
    value = module.blue_subnet.WebServer-ElasticIP
}