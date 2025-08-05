variable "vpc_cidr" {}
variable "nome_vpc" {}
variable "subnet_publica_cidr" {}
variable "sa_az" {}
variable "subnet_privada_cidr" {}

output "id_vpc_projeto" {
  value = aws_vpc.projeto_vpc_sa_zn.id
}

output "subnet_publica_projeto" {
  value = aws_subnet.subnet_publica_projeto.*.id
}

output "subnet_publica_cidr_block" {
  value = aws_subnet.subnet_publica_projeto.*.cidr_block
}

# configuração VPC
resource "aws_vpc" "projeto_vpc_sa_zn" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.nome_vpc
  }
}


# configuracao subnet publica
resource "aws_subnet" "subnet_publica_projeto" {
  count             = length(var.subnet_publica_cidr)
  vpc_id            = aws_vpc.projeto_vpc_sa_zn.id
  cidr_block        = element(var.subnet_publica_cidr, count.index)
  availability_zone = element(var.sa_az, count.index)

  tags = {
    Name = "subnet-publica-projeto-${count.index + 1}"
  }
}

# configuracao subnet privada
resource "aws_subnet" "subnet_privada_projeto" {
  count             = length(var.subnet_privada_cidr)
  vpc_id            = aws_vpc.projeto_vpc_sa_zn.id
  cidr_block        = element(var.subnet_privada_cidr, count.index)
  availability_zone = element(var.sa_az, count.index)

  tags = {
    Name = "subnet-privada-projeto-${count.index + 1}"
  }
}

# configuracao Internet Gateway
resource "aws_internet_gateway" "gateway_pulico_projeto" {
  vpc_id = aws_vpc.projeto_vpc_sa_zn.id
  tags = {
    Name = "gw-projeto"
  }
}

# tabela rota publica
resource "aws_route_table" "tabela_rota_publica_projeto" {
  vpc_id = aws_vpc.projeto_vpc_sa_zn.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_proj_1_public_internet_gateway.id
  }
  tags = {
    Name = "rt-projeto"
  }
}

# rota publica e subnet publica
resource "aws_route_table_association" "rt_subnet-associacao" {
  count          = length(aws_subnet.subnet_publica_projeto)
  subnet_id      = aws_subnet.subnet_publica_projeto[count.index].id
  route_table_id = aws_route_table.dev_proj_1_public_route_table.id
}

# Rota publica privada
resource "aws_route_table" "subnet_privada_projeto" {
  vpc_id = aws_vpc.projeto_vpc_sa_zn.id
  #depends_on = [aws_nat_gateway.nat_gateway]
  tags = {
    Name = "tr-privada-projeto"
  }
}

# TR privada e assosiacao subnet privada
 resource "aws_route_table_association" "rt_privada_assosiacao_subnet_privada" {
  count          = length(aws_subnet.dev_proj_1_private_subnets)
  subnet_id      = aws_subnet.dev_proj_1_private_subnets[count.index].id
  route_table_id = aws_route_table.dev_proj_1_private_subnets.id
}