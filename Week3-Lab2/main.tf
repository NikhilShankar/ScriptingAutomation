provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "niks-aws-apache-sg" {
  name        = "niks-aws-apache-sg"
  description = "Security group for Apache server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}


data "aws_ssm_parameter" "niks-aws-ec2-ami-id" {
    name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "niks-apache-server" {
    ami = data.aws_ssm_parameter.niks-aws-ec2-ami-id.value
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.niks-aws-apache-sg.id]

    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "<h1>Hello from Niks AWS Apache Server</h1>" > /var/www/html/index.html
            EOF
}

output "instance_id" {
  value = aws_instance.niks-apache-server.public_ip
}