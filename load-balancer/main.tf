variable "nome_lb" {}
variable "tipo_lb" {}
variable "e_externo" { default = false }
variable "gs_ativa_ssh_http" {}
variable "subnet_ids" {}
variable "nome_tag" {}
variable "grupo_lb" {}
variable "id_istancia_ec2" {}
variable "porta_entrada_lb" {}
variable "protocolo_entrada_lb" {}
variable "lb_acao_entrada" {}
variable "porta_entrada_lb_http" {}
variable "protocolo_http_lb" {}
variable "projeto_acm_arn" {}
variable "porta_conexao_grupo_lb" {}

output "aws_lb_nome_dns" {
  value = aws_lb.projeto_lb.nome_dns
}

output "aws_lb_zone_id" {
  value = aws_lb.projeto_lb.zone_id
}


resource "aws_lb" "projeto_lb" {
  name               = var.nome_lb
  internal           = var.e_externo
  load_balancer_type = var.tipo_lb
  security_groups    = [var.gs_ativa_ssh_http]
  subnets            = var.subnet_ids # Replace with your subnet IDs

  enable_deletion_protection = false

  tags = {
    Name = "example-lb"
  }
}

resource "aws_lb_target_group_attachment" "projeto_lb_target_group_attachment" {
  target_group_arn = var.grupo_lb
  target_id        = var.id_istancia_ec2 # trocar por sua referencia da instacia
  port             = var.porta_conexao_grupo_lb
}

resource "aws_lb_listener" "projeto_lb_listner" {
  load_balancer_arn = aws_lb.projeto_lb.arn
  port              = var.porta_entrada_lb
  protocol          = var.protocolo_entrada_lb

  default_action {
    type             = var.lb_acao_entrada
    target_group_arn = var.grupo_lb
  }
}

# https ouvinte na porta 443
resource "aws_lb_listener" "projeto_lb_https_listner" {
  load_balancer_arn = aws_lb.projeto_lb.arn
  port              = var.lb_https_listner_port
  protocol          = var.protocolo_http_lb
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn   = var.projeto_acm_arn

  default_action {
    type             = var.lb_acao_entrada
    target_group_arn = var.grupo_lb
  }
}