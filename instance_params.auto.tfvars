# AWS region us-east-2 is in Ohio.
# You may wish to choose the region geographically closest
# to you to reduce latency.
# For a list of available AWS regions, see:
# https://docs.aws.amazon.com/AmazonRDS/latest/
# UserGuide/Concepts.RegionsAndAvailabilityZones.html
#
region = "us-east-2"

# Set the instance type.
# A c7a.large instance is a 2 core, CPU optimized machine.
# Learn more about AWS instance types and pricing at:
# https://aws.amazon.com/ec2/instance-types/
#
instance_type = "c7a.large"

# Specify the amount of disk storage (in gigabytes).
# Different workloads may have different storage needs. 
# In AWS volume performance is tied to volume size.
# We recommend 100 GB or more for optimal performance.
# The maximum value accepted is 2048 GB (2 TB)
#
volume_size = 100




