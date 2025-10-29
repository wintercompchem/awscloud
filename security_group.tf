# This file is part of https://github.com/wintercompchem/awscloud 
#
# A Security Group provides a firewall to protect our instances
# We create the group and configure the rules here

# Create the security group
# Instances will join it as they are created
resource "aws_security_group" "Lab" {
  name   = var.title
  vpc_id = aws_vpc.Lab.id

  tags = {
    Name = var.title
  }
}

# Allow all traffic from our instances to the Internet
# This allows for downloading software from any source.
# It also allows for communication to the AWS APIs for ssm-agent.
resource "aws_security_group_rule" "outbound" {
  type        = "egress"
  protocol    = "tcp"
  from_port   = 0
  to_port     = 65535
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.Lab.id
}

# Expose Port 80 (http) to facilitate data download
# By default this is allowed from anywhere on the Internet
# If you'd like to restrict this (e.g. to a campus LAN)
# do so by setting the inbound_cidr_block variable in a .auto.tfvars file
# Allow no other inbound traffic
resource "aws_security_group_rule" "http" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = [var.inbound_cidr_block]

  security_group_id = aws_security_group.Lab.id
}
