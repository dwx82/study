/*

Credentials are stored in environment variables

*/
provider "aws" {
  region = var.region
}


#---------------------------------Data------------------------------------------
data "aws_region" "current" {}

data "aws_ami" "Ubuntu_22_latest" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name = "name"
    #  values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220609"]
  }
}

data "aws_ami" "CentOS_latest" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


#-------------------------------instances---------------------------------------

resource "aws_instance" "Ubuntu" {

  #  count                  = 1
  ami                         = data.aws_ami.Ubuntu_22_latest.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.exadel-public-subnet.id
  vpc_security_group_ids      = [aws_security_group.ubuntu_sg.id]
  key_name                    = "n_virginia"
  associate_public_ip_address = true

  user_data = file("userdataUbuntu.sh")

  tags = merge(var.common-tags, { Name = "Ubuntu" })
}

/*resource "aws_instance" "test" {

  #  count                  = 1
  ami                    = data.aws_ami.Ubuntu_22_latest.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.exadel-public-subnet.id
  vpc_security_group_ids = [aws_security_group.ubuntu_sg.id]
  key_name               = "n_virginia"

  user_data = file("userdataUbuntu.sh")

  tags = merge(var.common-tags, { Name = "TestConnectivity" })
}
*/
resource "aws_instance" "CentOS" {

  #  count                  = 1
  ami           = data.aws_ami.CentOS_latest.id
  instance_type = var.instance_type
  #subnet_id                   = aws_subnet.exadel-private-subnet.id
  subnet_id                   = aws_subnet.exadel-public-subnet.id
  vpc_security_group_ids      = [aws_security_group.centos_sg.id]
  key_name                    = "n_virginia"
  associate_public_ip_address = false

  #  user_data              = file("userdataCentOS.sh")

  tags = merge(var.common-tags, { Name = "CentOS" })

  depends_on = [aws_instance.Ubuntu]
}
