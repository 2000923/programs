variable "aws_region" {
  description = "Region de AWS"
}

variable "aws_instance_type" {
  description = "Tipo de instancia de AWS"
}

variable "aws_ami_id" {
  description = "ID de la AMI de AWS"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "example" {
  ami           = var.aws_ami_id
  instance_type = var.aws_instance_type
}
