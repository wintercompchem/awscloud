# Return the generated password for the created IAM user

output "password" {
  value = aws_iam_user_login_profile.student.password
}
