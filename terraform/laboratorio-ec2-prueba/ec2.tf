resource "aws_volume_attachment" "ebs_node01" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.node01.id
}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 6
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.SN_pub_a.id
  private_ips = ["10.142.6.15"]
  # Asociar el Security Group "SG_default" creado anteriormente
  security_groups = ["${aws_security_group.SG_default.id}"]

  tags = {
    Name = "private_network_interface"
  }
}

resource "aws_instance" "node01" {
  # AMI (imagen de SO) de Amazon Linux 2 AMI (HVM), SSD Volume Type en
  # la region North Virginia
  ami = "ami-0c101f26f147fa7fd"

  # Tamanio de instancia
  instance_type = "t2.micro"

  # Keypair SSH a usar con esta instancia
  key_name = aws_key_pair.KP-ssh.id

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

  user_data = templatefile("${path.module}/templates/bastion_setup.tpl", {})

  tags = {
    Name = "bastion.hacom.com"
  }
}

resource "aws_network_interface" "foo2" {
  subnet_id   = aws_subnet.SN_pub_a.id
  private_ips = ["10.142.6.16"]
  # Asociar el Security Group "SG_default" creado anteriormente
  security_groups = ["${aws_security_group.SG_default.id}"]

  tags = {
    Name = "private_network_interface"
  }
}

resource "aws_instance" "node02" {
  # AMI (imagen de SO) de Amazon Linux 2 AMI (HVM), SSD Volume Type en
  # la region North Virginia
  ami = "ami-0c101f26f147fa7fd"

  # Tamanio de instancia
  instance_type = "t2.micro"

  # Keypair SSH a usar con esta instancia
  key_name = aws_key_pair.KP-ssh.id

  network_interface {
    network_interface_id = aws_network_interface.foo2.id
    device_index         = 0
  }

  user_data = templatefile("${path.module}/templates/bastion_setup.tpl", {})

  tags = {
    Name = "monitoreo.hacom.com"
  }
}

