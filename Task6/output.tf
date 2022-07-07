output "CentOS_ami_id" {
  value = data.aws_ami.CentOS_latest.id
}

output "Ansible_public_ip" {
  value = aws_instance.Ansible.public_ip
}

output "Jenkins_public_ip" {
  value = aws_instance.Ubuntu.public_ip
}
