
resource "aws_eip" "eip_manager" {
  instance = aws_instance.node01.id
  vpc = true

  tags = {
    Name = "eip-${var.ec2ResourceName}"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.node01.id
  allocation_id = aws_eip.eip_manager.id
}
