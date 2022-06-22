/*provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "exadel-terraform-files"
    key    = "dev/network/terraform.tfsate"
    region = "us-east-1"
  }
}*/
#--------------------------------VPC--------------------------------------------
resource "aws_vpc" "exadel-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "Exadel-VPC"
  }
}
#------------------------------Subnets------------------------------------------
resource "aws_subnet" "exadel-public-subnet" {
  vpc_id                  = aws_vpc.exadel-vpc.id
  cidr_block              = "172.16.0.0/28"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  tags = {
    Name = "Exadel-Public-Subnet"
  }
}

resource "aws_subnet" "exadel-private-subnet" {
  vpc_id                  = aws_vpc.exadel-vpc.id
  cidr_block              = "172.16.0.16/28"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "Exadel-Private-Subnet"
  }
}
#-------------------------------GW----------------------------------------------
resource "aws_internet_gateway" "exadel-igw" {
  vpc_id = aws_vpc.exadel-vpc.id
  tags = {
    Name = "EXADEL-VPC-IGW"
  }
}
#------------------------------Routes-------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.exadel-vpc.id

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //uses this IGW to reach internet
    gateway_id = aws_internet_gateway.exadel-igw.id
  }

  tags = {
    Name = "Exadel"
  }
}

resource "aws_route_table_association" "public-subnet" {
  subnet_id      = aws_subnet.exadel-public-subnet.id
  route_table_id = aws_route_table.public.id
}

#----------------------------SG-Ubutu-------------------------------------------
resource "aws_security_group" "ubuntu_sg" {
  name        = "web_ssh_icmp_ubuntu"
  description = "allow_web_ssh_icmp_allout"
  vpc_id      = aws_vpc.exadel-vpc.id

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_ssh_icmp_ubuntu"
  }
}
#----------------------------SG-CentOS------------------------------------------
resource "aws_security_group" "centos_sg" {
  name        = "web_ssh_icmp_centos"
  description = "allow_web_ssh_icmp_allout"
  vpc_id      = aws_vpc.exadel-vpc.id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["${aws_instance.Ubuntu.private_ip}/32"]
    }
  }

  dynamic "egress" {
    for_each = var.allowed_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["${aws_instance.Ubuntu.private_ip}/32"]
    }
  }

  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["${aws_instance.Ubuntu.private_ip}/32"]
  }


  egress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["${aws_instance.Ubuntu.private_ip}/32"]
  }

  tags = {
    Name = "web_ssh_icmp_CentOS"
  }
  depends_on = [aws_instance.Ubuntu]
}
