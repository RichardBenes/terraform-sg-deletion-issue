# Terraform - security group deletion issue

*(btw. the key pair under keys/ is revoked)*

## What's up?

When terraform configuration changes, one of the security group cannot be
deleted (one instance that is using it has to be deleted first) - so the
process gets stuck, until the security group is manually unassigned.

The question is - is this a bug in Terraform (is Terraform supposed to be able
to handle such case), or is it something that user just has to think about?

## How to recreate the issue?

First, authorize the terraform to access your AWS account.

Then create a key pair called `infstr-from-ntb`, type RSA (I used the PEM format
for downloading the private key, but I guess that doesn't matter).

Clone the repo, `cd` there, checkout the `be81b79` commit, and let
terraform create the infrastructure:

```PowerShell
git clone https://github.com/RichardBenes/terraform-sg-deletion-issue
cd terraform-sg-deletion-issue
git checkout be81b79
terraform init
terraform plan
terraform apply
```

Now you should have some infrastructure created - this part should be without
any issues.

Then checkout the `37206e0`, and apply the changes (new module is introduced,
so you have to init terraform once again):

```PowerShell
git checkout 37206e0
terraform init # yellow_subnet module is added
terraform plan
terraform apply
```

And when you hit the `apply` command, the process gets stuck at the destruction
of the `module.blue_subnet.aws_security_group.WS` security group:

```txt
  Enter a value: yes

module.blue_subnet.aws_security_group.WS: Destroying... [id=sg-07d1c8f7885be6ef9]
module.yellow_subnet.aws_subnet.subnet: Creating...
module.yellow_subnet.aws_security_group.WS: Creating...
module.yellow_subnet.aws_security_group.WS: Still creating... [10s elapsed]
module.yellow_subnet.aws_subnet.subnet: Still creating... [10s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 10s elapsed]
module.yellow_subnet.aws_subnet.subnet: Creation complete after 12s [id=subnet-08650296fcbe019ab]
module.yellow_subnet.aws_security_group.WS: Still creating... [20s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 20s elapsed]
module.yellow_subnet.aws_security_group.WS: Still creating... [30s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 30s elapsed]
module.yellow_subnet.aws_security_group.WS: Creation complete after 40s [id=sg-090a6762126f83bbb]
module.yellow_subnet.aws_network_interface.nic: Creating...
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 40s elapsed]
module.yellow_subnet.aws_network_interface.nic: Still creating... [10s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 50s elapsed]
module.yellow_subnet.aws_network_interface.nic: Creation complete after 11s [id=eni-020743a198f238ce0]
module.yellow_subnet.aws_instance.webserver: Creating...
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 1m0s elapsed]
module.yellow_subnet.aws_instance.webserver: Still creating... [10s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 1m10s elapsed]
module.yellow_subnet.aws_instance.webserver: Still creating... [20s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 1m20s elapsed]
module.yellow_subnet.aws_instance.webserver: Still creating... [30s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 1m30s elapsed]
module.yellow_subnet.aws_instance.webserver: Still creating... [40s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 1m40s elapsed]
module.yellow_subnet.aws_instance.webserver: Still creating... [50s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 1m50s elapsed]
module.yellow_subnet.aws_instance.webserver: Still creating... [1m0s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 2m0s elapsed]
module.yellow_subnet.aws_instance.webserver: Still creating... [1m10s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 2m10s elapsed]

# (output ommited)

module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 2m40s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 2m50s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 3m0s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 3m10s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 3m20s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 3m30s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 3m40s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 3m50s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 4m0s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 4m10s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 4m20s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 4m30s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 4m40s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 4m50s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 5m0s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 5m10s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 5m20s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 5m30s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 5m40s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 5m50s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 6m0s elapsed]
```

One solution is going to the AWS console, and manually unassign the `WS`
security group from the `WebServerInBlue` EC2 instance (and replace it for
example by the `default` security group):

```txt
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 8m10s elapsed]
module.blue_subnet.aws_security_group.WS: Still destroying... [id=sg-07d1c8f7885be6ef9, 8m20s elapsed]

# The WS security group was manually unassigned from the WebServerInBlue

module.blue_subnet.aws_security_group.WS: Destruction complete after 8m27s
module.blue_subnet.aws_security_group.WS: Creating...
module.blue_subnet.aws_security_group.WS: Still creating... [10s elapsed]
module.blue_subnet.aws_security_group.WS: Still creating... [20s elapsed]
module.blue_subnet.aws_security_group.WS: Still creating... [30s elapsed]
module.blue_subnet.aws_security_group.WS: Creation complete after 39s [id=sg-08fdadb8ea6b5804e]
module.blue_subnet.aws_network_interface.nic: Modifying... [id=eni-0210fc94b19e17a2e]
module.blue_subnet.aws_network_interface.nic: Modifications complete after 6s [id=eni-0210fc94b19e17a2e]

Apply complete! Resources: 6 added, 1 changed, 1 destroyed.

Outputs:

WebServer1-ElasticIP = "3.122.149.178"
WebServer1-ID = "i-0a00d17d010b7bf37"
WebServer2-ElasticIP = "3.72.169.175"
WebServer2-ID = "i-096c6c40cd124280d"
WebServerInBlue-ElasticIP = "18.184.70.180"
WebServerInBlue-ID = "i-073358b69f9ddf3b7"
WebServerInYellow-ElasticIP = "52.57.135.40"
WebServerInYellowe-ID = "i-0ee564d4dce3e37e7"
```
