# This file is part of https://github.com/wintercompchem/awscloud 
#
# Create an AWS user for the student
resource "aws_iam_user" "student" {
  name          = var.name
  force_destroy = true
}

# Allow login via the AWS console
resource "aws_iam_user_login_profile" "student" {
  user                    = aws_iam_user.student.name
  password_reset_required = false
}

# Create an IAM policy allowing use of Systems Manager
# to login to a specific instance
resource "aws_iam_policy" "student-ssm" {
  name   = var.name
  policy = templatefile("${path.module}/ssm-policy.json.tpl", { arn = aws_instance.student.arn })
}

# Assign the created IAM policy to the student
resource "aws_iam_user_policy_attachment" "student-ssm" {
  user       = aws_iam_user.student.name
  policy_arn = aws_iam_policy.student-ssm.arn
}

# Allows the student to:
# View all EC2 instances to locate their assigned instance
resource "aws_iam_user_policy_attachment" "student-ec2" {
  user       = aws_iam_user.student.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}
