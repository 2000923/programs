terraform {
  backend "s3" {
    bucket                  = "eflores-terraform-s3-state"
    key                     = "my-terraform-project"
    region                  = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = "~/.aws/credentials"
}
