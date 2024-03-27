provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["/home/eflores/.aws/credentials"]
}

variable "zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
