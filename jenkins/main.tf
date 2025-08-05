variable "ami_id" {}
variable "tipo_instancia" {}
variable "nome_tag" {}
variable "chave_publica" {}
variable "id_subnet" {}
variable "gs_junkins" {}
variable "endereco_ip_publico" {}
variable "user_data_install_jenkins" {}

output "conexao_ssh_ec2" {
  value = format("%s%s", "ssh -i /Users/$USER/.ssh/aws_ec2_terraform ubuntu@", aws_instance.instancia_ec2_jenkins.public_ip)
}

output "instancia_ec2_jenkins" {
  value = aws_instance.instancia_ec2_jenkins.id
}

output "instancia_ec2_ip_publico" {
  value = aws_instance.instancia_ec2_jenkins.public_ip
}

resource "aws_instance" "instancia_ec2_jenkins" {
  ami           = var.ami_id
  tipo_instancia = var.tipo_instancia
  tags = {
    Name = var.nome_tag
  }
  key_name                    = "aws_ec2_terraform"
  id_subnet                   = var.id_subnet
  vpc_security_group_ids      = var.gs_junkins
  associate_public_ip_address = var.endereco_ip_publico

  user_data = var.user_data_install_jenkins

  metadata_options {
    http_endpoint = "enabled"  #ativar IMDSv2 endpoint
    http_tokens   = "required" # precisa dos IMDSv2 tokens
  }
}

resource "aws_key_pair" "jenkins_ec2_instance_chave_publica" {
  key_name   = "aws_ec2_terraform"
  chave_publica = var.chave_publica
}