# Local name for ressources
locals {
  name="labjenkins"
}

#RSA key of size 4096 bits
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

#creating private key
resource "local_file" "key" {
  content = tls_private_key.key.private_key_pem
  filename = "cicdkey"
  file_permission = "600"
}

//creating and register public key in AWS
resource "aws_key_pair" "key" {
  key_name = "cicd-pub-key"
  public_key = tls_private_key.key.public_key_openssh
}


resource "aws_security_group" "prod-sg" {
  name = "prod-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"

  ingress {
    description = "ssh"
    from_port = var.sshport
    to_port = var.sshport
    protocol = "tcp"
    cidr_blocks = [var.allcidr]
  }

  ingress {
    description = "java"
    from_port = var.javaport
    to_port = var.javaport
    protocol = "tcp"
    cidr_blocks = [var.allcidr]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.allcidr]
  }
  tags = {
    name = "${local.name}-prod-sg"
  }
  
}

#creating maven server
resource "aws_instance" "jenkins_server" {
  ami                           = var.redhat
  instance_type                 = "t2.medium"
  key_name                      = aws_key_pair.key.id
  vpc_security_group_ids        = [aws_security_group.prod-sg.id]
  associate_public_ip_address   = true
  user_data                     = file("./userdata-jenkins.sh")
  tags = {
    name = "${local.name}-jenkins-server"
  }
}

#creating prod server
resource "aws_instance" "prod_server" {
  ami                           = var.redhat
  instance_type                 = "t2.medium"
  key_name                      = aws_key_pair.key.id
  vpc_security_group_ids        = [aws_security_group.prod-sg.id]
  associate_public_ip_address   = true
  user_data                     = file("./userdata-prod.sh")
  tags = {
    name = "${local.name}-prod-server"
  }
}