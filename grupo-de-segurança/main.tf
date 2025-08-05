variable "gs_ec2_nome" {}
variable "vpc_id" {}
variable "gs_jenkins_ec2_nome" {}

output "gs_ssh_gs_ec2" {
  value = aws_security_group.ec2_sg_ssh_http.id
}

output "porta_8080_gs" {
  value = aws_security_group.porta_8080_ec2_jenkins.id
}

resource "aws_security_group" "ec2_sg_ssh_http" {
  name        = var.ec2_sg_name
  description = "ativar the Port 22(SSH) & Port 80(http)"
  vpc_id      = var.vpc_id

  # ssh para terraform remote exec
  ingress {
    description = "SSH remoto"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # ativar http
  ingress {
    description = "requisicao http"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  # ativar http
  ingress {
    description = "requisicao http"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  #requisicao de saida
  egress {
    description = "permitir requisicao de saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Grupo de segurança para SSH(22) and HTTP(80)"
  }
}

resource "aws_security_group" "porta_8080_ec2_jenkins" {
  name        = var.gs_ec2_jenkins_nome
  description = "ativar porta 8080 para jenkins"
  vpc_id      = var.vpc_id

  # ssh para terraform remote exec
  ingress {
    description = "permitir acesso a porta 8080 para jenkins"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }

  tags = {
    Name = "grupo de segurança para SSH(22) and HTTP(80)"
  }
}

