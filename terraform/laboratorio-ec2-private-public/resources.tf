resource "aws_key_pair" "KP-ssh" {
  key_name   = "KP-ssh-eflores"
  public_key = file("${var.PUBLIC_KEY}")
}

resource "aws_vpc" "VPC_1" {
  cidr_block = "10.142.0.0/16"
  tags = {
    Name = "VPC_hacom"
  }
}

resource "aws_subnet" "SN_pub_a" {
  vpc_id            = aws_vpc.VPC_1.id
  cidr_block        = "10.142.1.0/24"
  availability_zone = "us-east-1a"
  # map_public_ip_on_launch = true
  tags = {
    Name = "SN_pub_a_oym"
  }
}

resource "aws_subnet" "SN_pri_b" {
  vpc_id            = aws_vpc.VPC_1.id
  cidr_block        = "10.142.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "SN_pri_b_servicio"
  }
}

resource "aws_subnet" "SN_pri_c" {
  vpc_id            = aws_vpc.VPC_1.id
  cidr_block        = "10.142.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "SN_pri_c_backup"
  }
}

resource "aws_internet_gateway" "IGW_1" {
  vpc_id = aws_vpc.VPC_1.id
  tags = {
    Name = "IGW-hacom"
  }
}

resource "aws_route_table" "RT_1" {
  vpc_id = aws_vpc.VPC_1.id
  tags = {
    Name = "RT_SN_pub"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW_1.id
  }
}

resource "aws_route_table_association" "RTASOC_1" {
  subnet_id      = aws_subnet.SN_pub_a.id
  route_table_id = aws_route_table.RT_1.id
}

resource "aws_security_group" "SG_default" {
  name        = "SG_default-hacom"
  vpc_id      = aws_vpc.VPC_1.id
  description = "Permitir trafico ssh"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3128
    to_port     = 3128
    protocol    = "tcp"
    cidr_blocks = ["10.142.1.0/24"]
  }
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["10.142.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SG_default-hacom"
  }
}
resource "aws_security_group" "SG_default_private" {
  name        = "SG_default_private-hacom"
  vpc_id      = aws_vpc.VPC_1.id
  description = "Permitir trafico private tcp/9090 servicio"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "${aws_subnet.SN_pub_a.cidr_block}"
    ]
  }
  ingress {
    from_port = 9090
    to_port   = 9090
    protocol  = "tcp"
    cidr_blocks = [
      "10.142.1.15/32"
    ]
  }
  ingress {
    from_port = 3100
    to_port   = 3100
    protocol  = "tcp"
    cidr_blocks = [
      "${aws_subnet.SN_pri_b.cidr_block}"
    ]
  }
  ingress {
    from_port = 5040
    to_port   = 5040
    protocol  = "tcp"
    cidr_blocks = [
      "${aws_subnet.SN_pri_c.cidr_block}"
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SG_default_private-hacom"
  }
}
