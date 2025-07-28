# Call the student module to create an EC2 instance and a AWS console login for each student

module "student" {
  source = "./per-student"

  for_each = toset(var.students)

  name              = each.key
  instance_profile  = aws_iam_instance_profile.ssm-profile.name
  instance_type     = var.instance_type
  security_group_id = aws_security_group.Lab.id
  subnet_id         = aws_subnet.Lab.id
  init_commands     = var.init_commands
  volume_size       = var.volume_size
}
