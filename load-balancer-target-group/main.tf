variable "lb_grupo_nome" {}
variable "lb_grupo_porta" {}
variable "lb_grupo_protocolo" {}
variable "vpc_id" {}
variable "instancia_ec2_id" {}

output "lb_projeto_arn" {
  value = aws_lb_target_group.lb_projeto_grupo.arn
}

resource "aws_lb_target_group" "lb_projeto_grupo" {
  name     = var.lb_grupo_nome
  port     = var.lb_grupo_porta
  protocol = var.lb_grupo_protocolo
  vpc_id   = var.vpc_id
  health_check {
    path = "/login"
    port = 8080
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  # has to be HTTP 200 or fails
  }
}

resource "aws_lb_target_group_attachment" "lb_projeto_grupo_attachment" {
  target_group_arn = aws_lb_target_group.lb_projeto_grupo.arn
  target_id        = var.instancia_ec2_id
  port             = 8080
}