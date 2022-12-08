# Security Group for Jenkins
resource "aws_security_group" "jenkins_allow_ssh" {
  name        = "jenkins_allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${var.vpc_id}"
  count = var.allow_jenkins_ssh ? 1 : 0


  ingress {
    description      = "SSH from my IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${var.my_ip_address}"]
  }

  tags = {
    Name = "jenkins_allow_ssh"
  }

}

resource "aws_security_group" "jenkins_allow_http" {
  name        = "jenkins_allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description      = "Jenkins HTTP from my IP"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["${var.my_ip_address}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jenkins_allow_http"
  }
}

resource "random_id" "id" {
	  byte_length = 8
}

resource "aws_s3_bucket" "jenkins_user_data" {
   bucket = "jenkins-user-data-${random_id.id.hex}"
}

resource "aws_s3_bucket_acl" "jenins_user_data_bucket_acl" {
  bucket = aws_s3_bucket.jenkins_user_data.id
  acl    = "private"
}

# Setup S3 bucket for user data scripts
resource "aws_s3_object" "jenkins_user_data" {
  for_each = fileset("${path.module}/scripts/", "*")
  bucket = aws_s3_bucket.jenkins_user_data.id
  key = each.value
  source = "${path.module}/scripts/${each.value}"
  etag = filemd5("${path.module}/scripts/${each.value}")
}

# Create IAM role for Jenkins instance
resource "aws_iam_role" "jenkins_iam_role" {
    name = "jenkins_iam_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "jenkins_iam_role_policy" {
  name = "jenkins_iam_role_policy"
  role = "${aws_iam_role.jenkins_iam_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["${aws_s3_bucket.jenkins_user_data.arn}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["${aws_s3_bucket.jenkins_user_data.arn}/*"]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "jenkins_instance_profile" {
    name = "jenkins_instance_profile"
    role = "jenkins_iam_role"
}

# Jenkins
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux2_ami.id
  instance_type = "t3.medium"
  key_name      = "${var.ssh_key_name}"
  vpc_security_group_ids = flatten([aws_security_group.jenkins_allow_http.id, var.allow_jenkins_ssh == "true" ? [aws_security_group.jenkins_allow_ssh[0].id] : []])
  user_data = <<EOF
#!/bin/bash
sudo yum update -y
mkdir /tmp/scripts
aws s3 cp s3://${aws_s3_bucket.jenkins_user_data.id}/ /tmp/scripts/ --recursive
sudo bash /tmp/scripts/ec2_setup.sh
  EOF
  iam_instance_profile = "${aws_iam_instance_profile.jenkins_instance_profile.id}"
  subnet_id = "${var.jenkins_public_subnet}"
  tags = {
    Name = "Jenkins"
  }
  depends_on = [aws_s3_object.jenkins_user_data]
}