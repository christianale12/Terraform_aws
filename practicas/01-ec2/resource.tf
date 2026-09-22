resource "aws_vpc" "lab" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-practica-01"
  }
}

resource "aws_subnet" "lab" {
  vpc_id     = aws_vpc.lab.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet-practica-01"
  }
}

resource "aws_security_group" "lab" {
  name        = "mi_primer_firewall"
  description = "no se que hace"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "HTTP no seguro"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-practica-01"
  }
}
resource "aws_instance" "maquina" {
  ami                    = data.aws_ami.UBUNTU.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.lab.id
  vpc_security_group_ids = [aws_security_group.lab.id]
  tags = {
    Name = "MiMaquinaVirtual"
  }
}
data "aws_ami" "UBUNTU" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*ubuntu*-amd64-server-*"]
  }
}