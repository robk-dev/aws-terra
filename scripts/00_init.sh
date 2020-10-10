mkdir prod
cd prod
cat > prod.tf <<EOF
provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_s3_bucket" "prod_infra_bucket" {
  bucket = "prod_infra_bucket"
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
EOF
# use actual IP address for cidr_blocks; ["0.0.0.0/0"] allows all traffic

terraform init
terraform apply -auto-approve
