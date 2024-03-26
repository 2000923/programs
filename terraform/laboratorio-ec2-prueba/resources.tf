# En este archivo se define todo el detalle de la infraestructura a crear
# a traves de multiples recursos de AWS
# El nombre del archivo es sugerido, pues puede ser diferente, siempre que se
# mantenga la extension .tf

# El recurso es de tipo "aws_key_pair" y de nombre interno "KP-ssh"
# Creacion de un Keypair SSH usado para autenticarse con una instancia EC2
resource "aws_key_pair" "KP-ssh" {
  # Nombre real del recurso de keypair SSH
  key_name = "KP-ssh-eflores"

  # Llave publica del keypair SSH.
  # Se apunta, a traves de la variable PUBLIC_KEY, a una ruta local
  # donde esta la llave publica a utilizar
  public_key = file("${var.PUBLIC_KEY}")
}

# Creacion de un VPC
resource "aws_vpc" "VPC_1" {
  # Rango de red base de la VPC
  cidr_block = "10.142.0.0/16"

  # Asignar un nombre al VPC usando tags
  tags = {
    Name = "VPC_test"
  }
}

# Creacion de subred privada A
resource "aws_subnet" "SN_pri_a" {
  # Asociar la subnet con el ID de la VPC creada antes
  vpc_id = aws_vpc.VPC_1.id

  # Segmento de red de la subnet
  cidr_block = "10.142.3.0/24"

  # Zona de disponibilidad donde crear la subnet
  availability_zone = "us-east-1a"

  # Asignar un nombre a la subnet usando tags
  tags = {
    Name = "SN_pri_a-10_142_3_0"
  }
}

# Creacion de subred privada B
resource "aws_subnet" "SN_pri_b" {
  # Asociar la subnet con el ID de la VPC creada antes
  vpc_id = aws_vpc.VPC_1.id

  # Segmento de red de la subnet
  cidr_block = "10.142.4.0/24"

  # Zona de disponibilidad donde crear la subnet
  availability_zone = "us-east-1b"

  # Asignar un nombre a la subnet usando tags
  tags = {
    Name = "SN_pri_b-10_142_4_0"
  }
}

# Creacion de subred publica A
resource "aws_subnet" "SN_pub_a" {
  # Asociar la subnet con el ID de la VPC creada antes
  vpc_id = aws_vpc.VPC_1.id

  # Segmento de red de la subnet
  cidr_block = "10.142.6.0/24"

  # Zona de disponibilidad donde crear la subnet
  availability_zone = "us-east-1a"

  # Asignar IPs publicas automaticamente a las instancias creadas en
  # esta subred
  map_public_ip_on_launch = true

  # Asignar un nombre a la subnet usando tags
  tags = {
    Name = "SN_pub_a-10_142_6_0"
  }
}

# Creacion de un Internet Gateway para la subred publica
resource "aws_internet_gateway" "IGW_1" {
  # Asociar el Internet Gateway con el ID de la VPC creada antes
  vpc_id = aws_vpc.VPC_1.id

  # Asignar un nombre al Internet Gateway usando tags
  tags = {
    Name = "IGW-test"
  }
}

# Creacion de una tabla de rutas para salida a Internet a traves del
# Internet Gateway
resource "aws_route_table" "RT_1" {
  # Asociar el Routa Table con el ID de la VPC creada antes
  vpc_id = aws_vpc.VPC_1.id

  # Asignar un nombre al Route Table usando tags
  tags = {
    Name = "RT_SN_pub"
  }

  # Detalles de la ruta
  route {
    # Direccion de red destino
    cidr_block = "0.0.0.0/0"

    # Enrutarlo por el Internet Gateway referenciandolo por su ID
    gateway_id = aws_internet_gateway.IGW_1.id
  }
}

# Asociar la subred publica con la tabla de enrutamiento creada
resource "aws_route_table_association" "RTASOC_1" {
  subnet_id      = aws_subnet.SN_pub_a.id
  route_table_id = aws_route_table.RT_1.id
}

# exterior y brinda salida libre a Internet
resource "aws_security_group" "SG_default" {
  # Nombre del Security Group
  name = "SG_default-oym"

  # Asociarlo con el VPC creado
  vpc_id = aws_vpc.VPC_1.id

  # Descripcion del Security Group
  description = "Permitir trafico SSH"

  # Reglas de entrada del exterior
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Reglas de salida al exterior
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Nombre del Security Group con tags
  tags = {
    Name = "SG_default-oym"
  }
}

