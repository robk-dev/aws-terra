variable "env" {
  type = string
}
variable "whitelist" {
  type = list(string)
}
variable "web_image_id" {
  type = string
}
variable "web_instance_type" {
  type = string
}
variable "web_desired_capacity" {
  type = number
}
variable "web_max_size" {
  type = number
}
variable "web_min_size" {
  type = number
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_s3_bucket" "prod_infra_bucket" {
  bucket = "prod-infra-bucket"
  acl    = "private"
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_default_vpc" "default" {}

data "aws_availability_zones" "available" {
  state = "available"
}

# e.g. Create subnets in the first two available availability zones

resource "aws_default_subnet" "primary" {
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    "Terraform" : "true"
    "env"       : var.env
  }
}

resource "aws_default_subnet" "secondary" {
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    "Terraform" : "true"
    "env"       : var.env
  }
}

resource "aws_security_group" "prod_web" {
  name        = "prod_web"
  description = "Allow http and https ports inbound and everything outbound"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.whitelist
  }

  tags = {
    "Terraform" : "true"
    "env"       : var.env
  }
}

module "web_app" {
  source = "./modules/web_app"

  web_app	             = "rypock"
  env                  = var.env
  web_image_id         = var.web_image_id
  web_instance_type    = var.web_instance_type
  web_desired_capacity = var.web_desired_capacity
  web_max_size         = var.web_max_size
  web_min_size         = var.web_min_size
  subnets              = [aws_default_subnet.primary.id,aws_default_subnet.secondary.id]
  security_groups      = [aws_security_group.prod_web.id]
}
