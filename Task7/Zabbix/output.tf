output "CentOS_ami_id" {
  value = data.aws_ami.CentOS_latest.id
}

output "Ubuntu_ami_id" {
  value = data.aws_ami.Ubuntu_22_latest.id
}

output "Zabbix-Server" {
  value = aws_instance.Ansible.public_ip
}

output "Ubuntu_public_ip" {
  value = aws_instance.Ubuntu[0].public_ip
}
