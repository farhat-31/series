# Latest Amazon Linux 2023 AMI (no hardcoded AMI id, works in any region)
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Use the account's default VPC
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web" {
  name        = "${var.name}-sg"
  description = "Allow HTTP in, all traffic out"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = <<-EOT
    #!/bin/bash
    dnf install -y httpd
    echo "<h1>Deployed by Terraform via Jenkins</h1>" > /var/www/html/index.html
    systemctl enable --now httpd
  EOT

  tags = {
    Name = "${var.name}-ec2"
  }
}
