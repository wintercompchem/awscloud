# Outputs a list of student usernames and passwords when 'terraform apply' is run
output "student_passwords" {
  value = { for student in var.students : student => module.student[student].password }
}
