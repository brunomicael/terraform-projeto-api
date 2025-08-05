variable "nome_bucket" {
  type        = string
  description = "nome do bucket Remote state "
}

variable "vpc_cidr" {
  type        = string
  description = "subnet publica CIDR "
}

variable "nome_vpc" {
  type        = string
  description = "vpc projeto"
}

variable "cidr_subnet_publica" {
  type        = list(string)
  description = "valores cidr_subnet_publica"
}

variable "cidr_subnet_privada" {
  type        = list(string)
  description = "valores cidr_subnet_privada"
}

variable "sa_AZ" {
  type        = list(string)
  description = "zona de disponibilidade"
}

variable "chave publica" {
  type        = string
  description = "chave publica do projeto"
}

variable "ec2_ami_id" {
  type        = string
  description = "AMI Id para a instancia EC2 do projeto"
}