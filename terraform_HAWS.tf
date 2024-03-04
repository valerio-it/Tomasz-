#--------------------------------------------
# Highly Availabe Web Server если один сервер загибается начинает рабоать другой 
# Create:
# 1.Security Group for Web Server
# 2. Automatic AMI
# 3. Auto Scaling Group in 2 Availability Zone
# 4. Cassic Load Balancer in 2 Availability Zone
#
# Made by Valery Vetkin
# ------------------------------------------

provider "aws" {
region = "us-east-1"
}

data "was_availability_zones" "available" {}
data "aws_ami" "linux_aws" {
  most_recent = true

  owners = ["137112412989"]
  tags = {
    Name   = "amzn2-ami-*-x86_64-gp2"
  }
}

#----------------------------------------------
# resource Security Group

resource "aws_security_group" "web" {
  name        = "Dynamic-Security-Group"

dynamic "ingress" {
  for_each = ["80", "443"]

content {
  from_port        = ingress.value
  to_port          = ingress.value
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  }
}

  ingress {
    from_port        = 80
    to_port          = 80
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

# create a new launch configuration with Auto AMI, used for autoscaling groups

resource "aws_launch_configuration" "web" {
  name          = "Highly-Availabe-Web-Server"
  image_id      = data.aws_ami.linux_aws.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web.id]
  user_data = <<EOF
#!/bin/bash
sudo yum install httpd
sudo systemctl start httpd
sudo systemctl status httpd

EOF
  }
}

# Auto Scaling Group in 2 Availability Zone

resource "Auto Scaling Group" "web" {
  name        = "Highly-Availabe-Web-Server-ASG"
  launch_configuration = aws_launch_configuration.web.name
  min_size = 2
  max_sinz = 2
  min_elb_capacity = 3
  vpc_zone_identifier = [aws_default_subnet.default_az1, aws_default_subnet.default_az2]
  health_check_type = "ELB"
  load_blancers = [WebServer-lb-ELB.name]


  tags = [
    {
      key                 = "Name"
      value               = "WbServer-in-ASG"
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = "Valery Vetkin"
      propagate_at_launch = true
  },
]

# Cassic Load Balancer in 2 Availability Zone

resource "aws_lb" "web" {
  name               = "WebServer-lb-ELB"
  availability_zones = [data.was_availability_zones.available.names[0], data.was_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.web.id]

  listener {
     instance_port     = 80
     instance_protocol = "http"
     lb_port           = 80
     lb_protocol       = "http"
   }

   health_check {
     healthy_threshold   = 2
     unhealthy_threshold = 2
     timeout             = 3
     target              = "HTTP:80/"
     interval            = 10

     tags = {
        Name = "WebServer-Highly-lb-ELB"
    }
}

#   vpc_zone_identifier

resource "aws_default_subnet" "default_az1" {
  availability_zone = "data.was_availability_zones.available.names[0]"
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "data.was_availability_zones.available.names[1]"


  }
}

# output DNS 

output "web_loadbalancer_url" {
value = aws_elb_web.dns_name
}

