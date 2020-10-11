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

resource "aws_s3_bucket" "storage_bucket" {
  bucket = "rypock-bucket"
  acl    = "private"
}

output "dns_name" {
  value = aws_s3_bucket.storage_bucket.bucket_domain_name
}
