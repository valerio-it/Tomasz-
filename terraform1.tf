provider "aws" { 
  access_key = ""
  secret_key = ""
  region = "us-east-1"
}
  
resource "aws_instance" "valery_aws2" { 

  ami               = "ami-0ed9277fb7eb570c9"
  instance_type     = "t2.micro"
}
 
