provider "aws" { 
  access_key = "AKIASG3HC56QRZIU5N5C"
  secret_key = "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"
  region = "us-east-1"
}
  
resource "aws_instance" "valery_aws2" { 

  ami               = "ami-0ed9277fb7eb570c9"
  instance_type     = "t2.micro"
}
 
