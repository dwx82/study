variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "allowed_ports" {
  type    = list(any)
  default = ["22", "443", "80"]
}

variable "common-tags" {
  type = map(any)
  default = {
    Owner   = "Vadim"
    Project = "Study"
  }
}

variable "vpc_cidr" {
  default = "172.16.0.0/24"
}
