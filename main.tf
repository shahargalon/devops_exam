provider "aws" {
  region     = "eu-central-1"
  ***REMOVED***                     # need to change this 
  ***REMOVED*** # need to change this
}

resource "aws_instance" "cassandra" {
  ami             = "ami-0b1deee75235aa4bb"
  instance_type   = "t2.medium"
  security_groups = ["allow_ssh", "allow_cassandra_ports"]
  count           = 2
  key_name        = "access-key.ec2"
  tags = {
    Name = element(var.machine_number, count.index)
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

output "instance_public_ip_1" {

  value = aws_instance.cassandra[0].public_ip
  depends_on = [
    aws_instance.cassandra
  ]
}

output "instance_public_ip_2" {

  value = aws_instance.cassandra[1].public_ip
  depends_on = [
    aws_instance.cassandra
  ]
}