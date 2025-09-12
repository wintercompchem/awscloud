# students, region, instance_type, volume_size and  init_commands should be set in a .auto.tfvars file
# see example files for how to do this
# 
# We have provided sensible defaults for the other variables, but
# they can be overridden in a .auto.tfvars file if needed


# 'title' is the value of the 'Project' tag for every resource created
# It is also used as the name of some of the resources
variable "title" {
  type    = string
  default = "AWS Comp Chem Lab"
}

# A list of students should be defined in a .auto.tfvars file
# We have provided an example: students.auto.tfvars
variable "students" {
  type = list(string)
}

# This variable will set the AWS region 
# You may wish to choose the region geographically closest to you to reduce latency
# The region variable must be specified in a .auto.tfvars file
# see the examples directory
# For a list of available AWS regions, see:
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html
variable "region" {
  type    = string
}

# Internet locations allowed to download output files
# (a password is always required)
# default allows everywhere on the internet
# You may be able to restrict to on campus locations
# Contact your IT department for values to use if desired
variable "inbound_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

# Created EC2 instances will have an assigned IP address from this range
variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

# The instance "type" specifies the number and type of cores and 
# amount of memory available.
# There are many different instance "families" optimized for
# different workloads.
# Learn more about AWS instance types and pricing at:
# https://aws.amazon.com/ec2/instance-types/
# The instance_type variable must be specified in a .auto.tfvars file
# see the examples directory
variable "instance_type" {
  type    = string
}

# The amount of disk storage (in gigabytes)
# different workloads will have different storage requirements,
# In AWS volume performance is tied to volume size.
# We recommend 100gb or more for optimal performance.
# The maximum value accepted is 2048 gigabytes (2 terrabytes)
variable "volume_size" {
  type    = number
}

# This variable holds an initializiation script to be run at instance boot time. 
# Use this to load your software.
# Note that:
# 1) The commands are run as root, so set ownership appropriately
# 2) Students will be logged in as the 'ssm-user' user
# 3) The instances will be running Ubuntu Linux 
#
# Set this variable in a .auto.tfvars file using heredoc syntax
# Example .auto.tfvars files have been included
variable "init_commands" {
  type    = string
  default = "/bin/true"
}

# This variable is meant to aid in debugging of initialization scripts
# when set to true the ssm-user will be allowed full use of sudo
# It is not adviseable to set this for student use
variable "debug" {
  type    = bool
  default = false
}
