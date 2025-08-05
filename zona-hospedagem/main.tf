variable "nome_dominio" {}
variable "aws_lb_dns_nome" {}
variable "aws_lb_id_zona" {}

data "aws_route53_zone" "devops_projeto_dominio" {
  name         = "" #dominio aqui
  private_zone = false
}

resource "aws_route53_record" "rota_dominio" {
  zone_id = data.aws_route53_zone.devops_projeto_dominio.zone_id
  name    = var.nome_dominio
  type    = "A"

  alias {
    name                   = var.aws_lb_dns_nome
    zone_id                = var.aws_lb_id_zona
    evaluate_target_health = true
  }
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.devops_projeto_dominio.zone_id
}
