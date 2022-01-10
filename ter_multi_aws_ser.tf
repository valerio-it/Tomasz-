#--------------------------------------------
# multiple AWS Regions EU and USA
#
# Made by Valery Vetkin
# ------------------------------------------

provider "aws" {
region = "us-east-1"
}

provider "aws" {
region = "eu-central-1"
alias = "USA"
}

provider "aws" {
region = "eu-central-1"
alias = "German"
}

#-------------------------------------------------

resource "aws_instance" "us_webserver" {
ami               = "ami-0ed9277fb7eb570c9"
instance_type     = "t2.micro"
tags {
  Name = "Default Server"
  }
}

resource "aws_instance" "eu_webserver" {
provider          = aws.USA
ami               = "ami-05d34d340fb1d89e5"
instance_type     = "t2.micro"
tags {
   Name = "Server in EU"
   }
}

resource "aws_instance" "eu_webserver" {
provider          = aws.German
ami               = "ami-05d34d340fb1d89e5"
instance_type     = "t2.micro"
tags {
   Name = "Server in EU"
   }
}
