variable "nome_dominio" {}
variable "id_zona" {}

output "projeto_devops" {
  value = aws_acm_certificate.projeto_devops.arn
}

resource "aws_acm_certificate" "projeto_devops" {
  nome_dominio       = var.nome_dominio
  validation_method = "DNS"

  tags = {
    Environment = "producao"
  }

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_route53_record" "validacao" {
  for_each = {
    for dvo in aws_acm_certificate.projeto_devops.domain_validation_options : dvo.nome_dominio => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.id_zona # mude para o seu id da zona
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

