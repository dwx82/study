resource "local_file" "inventory" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      awsip = aws_instance.CentOS.*.private_ip
    }
  )
  filename = "./Ansible/hosts.txt"
}
