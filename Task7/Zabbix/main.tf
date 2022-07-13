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
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "Ubuntu_22_latest" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name = "name"
    #  values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220610"]
  }
}

#-------------------------------instances---------------------------------------

resource "aws_instance" "Ubuntu" {

  count                       = 2
  ami                         = data.aws_ami.Ubuntu_22_latest.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.exadel-public-subnet.id
  vpc_security_group_ids      = [aws_security_group.centos_sg.id]
  key_name                    = "n_virginia"
  associate_public_ip_address = true

  #user_data = file("userdataUbuntu.sh")

  tags = merge(var.common-tags, { Name = "ZabbixAgent-${count.index + 1}" })
}

resource "aws_instance" "Ansible" {

  #count                       = 2
  ami                         = data.aws_ami.Ubuntu_22_latest.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.exadel-public-subnet.id
  vpc_security_group_ids      = [aws_security_group.centos_sg.id]
  key_name                    = "n_virginia"
  associate_public_ip_address = true

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/Users/vadimanpilogov/Downloads/AWS/n_virginia.cer")
  }

  //Data for Ansible
  provisioner "file" {
    source      = "/Users/vadimanpilogov/Google Drive/Documents/DevOpsStudy/Zabbix/Ansible"
    destination = "/home/ubuntu"
  }

  //ssh_key for Ansible
  provisioner "remote-exec" {
    inline = ["sudo chmod 400 /home/ubuntu/Ansible/n_virginia.cer"]
  }

  user_data = file("ansible.sh")

  tags = merge(var.common-tags, { Name = "Zabbix-Server" })

  depends_on = [aws_instance.Ubuntu]

}
