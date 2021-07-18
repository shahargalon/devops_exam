provider "aws" {
  region  = "eu-central-1"
  profile = "default"

}


locals {
  ami = "ami-0b1deee75235aa4bb"
}
resource "aws_instance" "cassandra" {
  ami             = local.ami
  instance_type   = "t2.medium"
  security_groups = ["allow_ssh", "allow_cassandra_ports"]
  count           = 2
  key_name        = "access-key.ec2"
  tags = {
    Name = element(var.machine_number, count.index)
    type = "cassandra"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"


  ingress {
    description = "SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "allow_cassandra_ports" {
  name        = "allow_cassandra_ports"
  description = "Allow allow cassandra inbound traffic"


  ingress {
    description = "cassandra traffic"
    from_port   = 7000
    to_port     = 7001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "cassandra traffic"
    from_port   = 7199
    to_port     = 7199
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "cassandra traffic"
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "cassandra traffic"
    from_port   = 9160
    to_port     = 9160
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "cassandra traffic"
    from_port   = 9142
    to_port     = 9142
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
