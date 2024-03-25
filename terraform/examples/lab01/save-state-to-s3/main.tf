terraform {
  backend "s3" {
    bucket                  = "eflores-terraform-s3-state"
    key                     = "my-terraform-project"
    region                  = "us-east-1"
  }
}

provider "aws" {
  region                   = "us-east-1"
  profile = "s3-database-548850886359"
}

resource "aws_s3_bucket" "New_bucket" {
  bucket = "my-personal-s3"
  acl = "private"

  tags = {
    Name = "eflores"
  }
}
