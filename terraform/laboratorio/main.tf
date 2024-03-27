variable "instance_name" {
  description = "SSAA-Canvia"
  type        = string
  default     = "mi-instancia"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "backend" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id

  tags = {
    name = var.instance_name
  }
}

resource "aws_network_interface" "eth1" {
  subnet_id   = aws_subnet.backend.id
  private_ips = ["10.0.2.100"]
  attachment {
    instance     = aws_instance.web.id
    device_index = 1
  }
}
