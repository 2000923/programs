resource "aws_network_interface" "foo" {
  subnet_id       = aws_subnet.SN_pub_a
  private_ips     = ["10.142.1.15"]
  security_groups = ["${aws_security_group.SG_default.id}"]
  tags = {
    Name = "public_network_interface"
  }
}

resource "aws_network_interface" "foo2" {
  subnet_id   = aws_subnet.SN_pri_b
  private_ips = ["10.142.2.15"]
  tags = {
    Name = "private_network_b"
  }
}

resource "aws_instance" "node01" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.KP-ssh
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.foo.id
  }
  tags = {
    Name = "bastion.hacom.com"
  }
}

resource "aws_instance" "node02" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.KP-ssh
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.foo2
  }
  tags = {
    Name = "monitoreo.hacom.com"
  }
}
