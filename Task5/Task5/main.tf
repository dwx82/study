/*

Credentials are stored in environment variables

*/
provider "aws" {
  region = var.region
}


#---------------------------------Data------------------------------------------
data "aws_region" "current" {}

data "aws_ami" "CentOS_latest" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


#-------------------------------instances---------------------------------------
resource "aws_instance" "CentOS" {

  count                       = 2
  ami                         = data.aws_ami.CentOS_latest.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.exadel-public-subnet.id
  vpc_security_group_ids      = [aws_security_group.centos_sg.id]
  key_name                    = "n_virginia"
  associate_public_ip_address = true

  tags = merge(var.common-tags, { Name = "CentOS-${count.index + 1}" })
}



resource "aws_instance" "Ansible" {

  #count         = 2
  ami                         = data.aws_ami.CentOS_latest.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.exadel-public-subnet.id
  vpc_security_group_ids      = [aws_security_group.centos_sg.id]
  key_name                    = "n_virginia"
  associate_public_ip_address = true

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/Users/vadimanpilogov/Downloads/AWS/n_virginia.cer")
  }

  //ssh_key for instances
  provisioner "file" {
    source      = "/Users/vadimanpilogov/Google Drive/Documents/DevOpsStudy/Terraform/Task5/Ansible"
    destination = "/home/ec2-user"
  }

  //ssh_key for containers and docker installation
  provisioner "remote-exec" {
#    inline = ["ssh-keygen -f /home/ec2-user/Ansible/Docker/mycontainerkey -N ''",
    "sudo chmod 600 /home/ec2-user/Ansible/n_virginia.cer" /*,
      "pip3 install ansible",
      "ansible-playbook playbook1.yml  2>/dev/null",
      "ansible-playbook playbook1.yml"
*/]
  }

  user_data = file("ansible.sh")

  tags = merge(var.common-tags, { Name = "Ansible" })

  depends_on = [aws_instance.CentOS]

}
