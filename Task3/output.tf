output "Ubuntu_ami_id" {
  value = data.aws_ami.Ubuntu_22_latest.id
}

output "CentOS_ami_id" {
  value = data.aws_ami.CentOS_latest.id
}
