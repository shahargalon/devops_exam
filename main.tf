provider "aws" {
  region     = "eu-central-1"
  ***REMOVED***                     # need to change this 
  ***REMOVED*** # need to change this
}

resource "aws_instance" "cassandra" {
  ami           = "ami-0b1deee75235aa4bb"
  instance_type = "t2.micro"
  # availability_zone = "eu-central-1"
  #associate_public_ip_address = ??? maybe
  security_groups = ["allow_ssh"]
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

}