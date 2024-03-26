variable "OS_USER" {}
variable "PRIVATE_KEY" {}
variable "PUBLIC_KEY" {}
variable "AWS_REGION" {
  default = "us-east-1"
}
variable "ec2ResourceName" {
  type    = string
  default = "ip-public"
}
