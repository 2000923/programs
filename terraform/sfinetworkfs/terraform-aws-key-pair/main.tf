resource "aws_key_pair" "this" {
  key_name        = var.key_name
  public_key      = var.public_key
  key_name_prefix = var.key_name_prefix

  tags = var.tags
}
