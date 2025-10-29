# This file is part of https://github.com/wintercompchem/awscloud 
#
# Creates an assigned student EC2 instance
resource "aws_instance" "student" {
  ami                         = data.aws_ami.ubuntu-linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  user_data                   = templatefile("${path.module}/user-data.sh.tpl", { init_commands = var.init_commands, student = var.name, password = aws_iam_user_login_profile.student.password, debug = var.debug })
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  iam_instance_profile        = var.instance_profile

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name = var.name
  }
}
