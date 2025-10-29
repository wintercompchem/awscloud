# This file is part of https://github.com/wintercompchem/awscloud 
#
# Find the most recent version of the Ubuntu 22.04 "Jammy" Amazon Machine Image for deployment

data "aws_ami" "ubuntu-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

# the owners number is Canonical's AWS account number
# Canonical is the company behind Ubuntu
  owners = ["099720109477"]
}
