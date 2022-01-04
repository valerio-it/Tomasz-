#----------------------------------------
# My Terraform
#
# Made by Valery Vetkin
#-----------------------------------------


provider "aws" {
region = "us-east-1"
}

resource "aws_instance" "my_webserver" {

ami               = "ami-0ed9277fb7eb570c9"
instance_type     = "t2.micro"
}

# Securyti group

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My First Security Group"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = <<EOF
#!/bin/bash
sudo yum install httpd
sudo systemctl start httpd
sudo systemctl status httpd

EOF

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
