resource "aws_eip" "eip_manager" {
  instance          = aws_instance.node01.id
  network_interface = aws_network_interface.eth0.id
  domain            = "vpc"
  tags = {
    Name = "eip-${var.ec2ResourceName}"
  }
}

resource "aws_eip_association" "eip_assoc" {
  allocation_id        = aws_eip.eip_manager.id
  network_interface_id = aws_network_interface.eth0.id
}
