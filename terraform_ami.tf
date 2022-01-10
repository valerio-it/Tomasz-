#----------------------------------------
# My Terraform
# AWS Autosearch AMI
# Made by Valery Vetkin
#-----------------------------------------

provider "aws" {
region = "us-east-1"
}

data "aws_ami" "linux_ubuntu" {
  most_recent = true

  owners = ["099720109477"]
  tags = {
    Name   = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"
  }
}


data "aws_ami" "linux_aws" {
  most_recent = true

  owners = ["137112412989"]
  tags = {
    Name   = "amzn2-ami-*-x86_64-gp2"
  }
}
