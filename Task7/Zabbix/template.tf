resource "local_file" "inventory" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      awsip = aws_instance.Ubuntu.*.private_ip
    }
  )
  filename = "./Ansible/hosts.txt"
}
