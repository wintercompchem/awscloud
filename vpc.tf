# This file is part of https://github.com/wintercompchem/awscloud 
#
# Virtual Private Cloud and related resources are created here

# A VPC requires a network range expressed in Classless Inter Domain Routing notation
# By default this is 10.0.0.0/16
# If you have a need to change this, you can set the vpc_cidr_block variables in a .auto.tfvars file
resource "aws_vpc" "Lab" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.title
  }
}

# AWS VPCs require an Internet Gateway in order to communicate to the internet.
# This is required in order to reach the instances to load software and download output files.
resource "aws_internet_gateway" "Lab" {
  vpc_id = aws_vpc.Lab.id

  tags = {
    Name = var.title
  }
}

# One default route to the internet
# This sends all non-local traffic via the Internet Gateway
resource "aws_route_table" "Lab" {
  vpc_id = aws_vpc.Lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Lab.id
  }
}

# One subnet is needed for our cloud instances
# It can take the entire VPC
resource "aws_subnet" "Lab" {
  vpc_id                  = aws_vpc.Lab.id
  cidr_block              = var.vpc_cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = var.title
  }
}

# Our subnet uses the route table to reach the Internet Gateway
resource "aws_route_table_association" "Lab" {
  subnet_id      = aws_subnet.Lab.id
  route_table_id = aws_route_table.Lab.id
}
