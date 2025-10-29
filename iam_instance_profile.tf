# This file is part of https://github.com/wintercompchem/awscloud 
#
# Create the Identity and Access Management resources that
# allow our instances to communicate with AWS Systems Manager
# 
# The ssm-agent process on the instance uses Systems Manager to allow shell login
# via the browser in the AWS console

resource "aws_iam_instance_profile" "ssm-profile" {
  name_prefix = "ssm-profile"
  role        = aws_iam_role.ssm-role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ssm-role" {
  name_prefix        = "ssm-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy_attachment" "AmazonSSMManagedInstanceCore" {
  name       = "ssm_policy_attachment"
  roles      = [aws_iam_role.ssm-role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
