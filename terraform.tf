terraform {
  # This lab was developed and tested on Terraform 1.5.4
  # Any 1.5.x version should work
  # Download Terraform and find installation instructions at:
  # https://developer.hashicorp.com/terraform/downloads
  required_version = "~> 1.5"

  required_providers {
    # This lab was developed and tested with Version 5.9 of the AWS provider
    # Any 5.x version should work
    # Terraform will download and install the provider for you
    aws = {
      source = "hashicorp/aws"
      #version = "5.17.0"
      version = ">= 5.9.0, <= 5.74.0"
    }
  }
}

provider "aws" {
  # AWS resources are created in the region specified in the 'region' variable
  # Set your preferred region in a .auto.tfvars file
  # See list of available regions at:
  # https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/using-regions-availability-zones.html#concepts-available-regions
  region = var.region

  default_tags {
    # Every resource created is tagged with a "Project" tag.
    # by default the value is "AWS Comp Chem Lab"
    # Change this by setting the title variable in a .auto.tfvars file
    tags = {
      Project = var.title
    }
  }
}
