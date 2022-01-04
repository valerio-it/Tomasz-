provider "aws" {
  access_key = ""
  secret_key = ""
  region = "us-east-1"
}

resource "aws_instance" "valery_aws2" {
  count             = 3
  ami               = "ami-0ed9277fb7eb570c9"
  instance_type     = "t2.micro"
}

}

resource "aws_instance" "valery_aws3" {

  ami               = "ami-061ac2e015473fbe2"
  instance_type     = "t2.micro"
}

