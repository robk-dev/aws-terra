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

# looks up latest official Ubuntu AMI
cat > aws_ec2_instance.tf <<EOF
resource "aws_instance" "robk_server" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
}

EOF

# static public IP address is called Elastic IP
cat > aws_static_ip.tf <<EOF
resource "aws_eip" "robk_server" {
  instance = "${aws_instance.robk_server}"
  vpc      = true
}

EOF

# cat > another_ec2.tf <<EOF
# resource "aws_instance" "web" {
#   count         = 2

#   ami           = "${data.aws_ami.ubuntu.id}"
#   instance_type = "t2.micro"

#   network_interface {
#       # ...
#   }

#   lifecycle {
#       create_before_destroy = true
#   }
# }

# EOF

# terraform apply