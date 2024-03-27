resource "aws_network_interface" "eth0" {
  subnet_id       = aws_subnet.SN_pub_a.id
  private_ips     = ["10.142.1.15"]
  security_groups = ["${aws_security_group.SG_default.id}"]
  tags = {
    Name = "public_network_interface"
  }
}

resource "aws_network_interface" "ens0" {
  subnet_id       = aws_subnet.SN_pub_a.id
  private_ips     = ["10.142.1.16"]
  security_groups = ["${aws_security_group.SG_default_private.id}"]
  tags = {
    Name = "public_network_interface"
  }
}

resource "aws_network_interface" "eth1" {
  subnet_id       = aws_subnet.SN_pri_b.id
  private_ips     = ["10.142.2.15"]
  security_groups = ["${aws_security_group.SG_default_private.id}"]
  tags = {
    Name = "private network interface"
  }
  attachment {
    instance     = aws_instance.node01.id
    device_index = 1
  }
}

resource "aws_network_interface" "ens1" {
  subnet_id       = aws_subnet.SN_pri_b.id
  private_ips     = ["10.142.2.16"]
  security_groups = ["${aws_security_group.SG_default_private.id}"]
  tags = {
    Name = "private network interface"
  }
  attachment {
    instance     = aws_instance.node02.id
    device_index = 1
  }
}

resource "aws_network_interface" "eth2" {
  subnet_id       = aws_subnet.SN_pri_c.id
  private_ips     = ["10.142.3.15"]
  security_groups = ["${aws_security_group.SG_default_private.id}"]
  tags = {
    Name = "private_c_network_interface"
  }
  attachment {
    instance     = aws_instance.node01.id
    device_index = 2
  }
}


resource "aws_network_interface" "ens2" {
  subnet_id       = aws_subnet.SN_pri_c.id
  private_ips     = ["10.142.3.16"]
  security_groups = ["${aws_security_group.SG_default_private.id}"]
  tags = {
    Name = "private network interface"
  }
  attachment {
    instance     = aws_instance.node02.id
    device_index = 2
  }
}

resource "aws_instance" "node01" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.small"
  key_name      = aws_key_pair.KP-ssh.id
  network_interface {
    network_interface_id = aws_network_interface.eth0.id
    device_index         = 0
  }
  tags = {
    Name = "bastion.hacom.com"
  }
}

resource "aws_instance" "node02" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.small"
  key_name      = aws_key_pair.KP-ssh.id
  network_interface {
    network_interface_id = aws_network_interface.ens0.id
    device_index         = 0
  }
  tags = {
    Name = "monitoreo.hacom.com"
  }
}
