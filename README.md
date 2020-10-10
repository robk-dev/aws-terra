# aws-terra

templates

## Init

```sh
./scripts/00_init.sh
./scripts/01_destroy_plan.sh
./scripts/02_state.sh
./scripts/03_resources.sh
```

```sh
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

terraform init
terraform apply

terraform plan -destroy -out=destroy.plan
terraform show destroy.plan
terraform apply destroy.plan

terraform apply -auto-approve
terraform state list
terraform show -json
terraform graph

cd ..
mkdir resources
cd resources

# public facing static site on bucket
cat > bucket_site.tf <<EOF
resource "aws_s3_bucket" "infra_bucket" {
  bucket = "robk-bucket-site"
  acl    = "public-read"
  policy = "${file("policy.json")}"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

EOF

cat > aws_default_vpc.tf <<EOF
resource "aws_default_vpc" "default" {
  tags = {
      Name = "Default VPC"
  }
}

EOF

cat > aws_security_group.tf <<EOF
resource "aws_security_group" "allow_tls" {
  ingress {
      from_port    = 443
      to_port      = 443
      protocol     = "tcp"
      cidr_blocks  = ["1.2.3.4/32"]
  }
  egress {
      from_port    = 0
      to_port      = 0
      protocol     = "-1"
  }
}

EOF

cat > aws_ec2_instance.tf <<EOF
resource "aws_instance" "robk_server" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
}

EOF

terraform apply
```

