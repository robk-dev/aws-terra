terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0708a0921e5eaf65d"
  instance_type = "t2.micro"
}