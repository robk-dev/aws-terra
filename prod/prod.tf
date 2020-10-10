provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_s3_bucket" "prod_infra_bucket" {
  bucket = "prod-infra-bucket"
  acl    = "private"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod_web" {
  name        = "prod_web"
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", "1.2.3.4/32"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0", "1.2.3.4/32"]
  }

  tags = {
    "Terraform": "true"
  }
}

resource "aws_instance" "prod_web" {
  ami           = "ami-0708a0921e5eaf65d"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]

  tags = {
    "Terraform": "true"
  }  
}

resource "aws_eip" "prod_web" {
  instance = aws_instance.prod_web.id

  tags = {
    "Terraform" = "true"
  }
}