# Projeto Terraform - API REST com Jenkins

Este projeto demonstra como provisionar uma infraestrutura completa na AWS usando Terraform, incluindo a configuração de um serviço REST API acessível através de um domínio personalizado, implantado em EC2 com dados armazenados em RDS MySQL.

## 📋 Visão Geral do Fluxo de Alto Nível

O fluxo de alto nível envolve:
- Acesso ao serviço REST API através de um domínio personalizado (`dominio`)
- Implantação em uma instância EC2
- Armazenamento de dados em uma instância RDS MySQL

## 🔧 Pré-requisitos e Configuração Inicial

### 1. Entendimento da Arquitetura
Familiarize-se com o fluxo geral e os componentes AWS envolvidos.

### 2. Repositório GitHub
O código Terraform para o projeto está disponível em: [`brunomicael/terraform-projeto-api`](https://github.com/brunomicael/terraform-projeto-api)

### 3. Credenciais AWS
- Crie uma chave de acesso e uma chave secreta para sua conta AWS
- Acesse o console AWS → "Security Credentials" → Criar nova chave de acesso
- Armazene as credenciais em um arquivo AWS credentials:
  ```bash
  # Linux/macOS
  ~/.aws/credentials
  ```

### 4. Instalar Terraform
Instale o Terraform em sua máquina local seguindo a [documentação oficial](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

### 5. Criar S3 Buckets para Remote State
Crie manualmente dois buckets S3 na AWS:
- **Jenkins Remote State**: `devops-project-jenkins-remote-state`
- **Python App Remote State**: `devops-project-python-remote-state`

Estes buckets armazenarão o estado do Terraform remotamente.

## 🚀 Fase 1: Configuração do Jenkins na Região SA East de preferencia

Esta fase foca em provisionar a infraestrutura necessária para o Jenkins e instalar o próprio Jenkins.

> **📁 Diretório de Trabalho**: Todos os comandos Terraform devem ser executados a partir do diretório raiz do repositório `brunomicael/terraform-projeto-api`.

### 1. Clonar o Repositório Terraform

```bash
git clone https://github.com/brunomicael/terraform-projeto-api.git
cd terraform-projeto-api
```

### 2. Configuração da Rede (VPC, Subnets, Internet Gateway, Route Tables)

#### VPC e Subnets
1. Abra o arquivo `main.tf` na raiz do repositório
2. Comente todos os módulos exceto o módulo de **rede** para focar na configuração inicial
3. Configure o VPC com bloco CIDR (ex: `11.0.0.0/16`)
4. As subnets terão blocos CIDR dentro do VPC (subnets públicas e privadas)

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

✅ **Verificação**: Confirme no console AWS (Região EU West 1) se o VPC e as subnets foram criados.

#### Internet Gateway (IGW)
1. No `main.tf` do módulo rede, habilite o recurso para o Internet Gateway
2. Permite acesso à internet para recursos na subnet pública

```bash
terraform apply -auto-approve
```

✅ **Verificação**: Confirme no console AWS se o IGW foi criado e anexado ao VPC.

#### Tabelas de Roteamento
1. Habilite os módulos para duas tabelas de roteamento:
   - **Pública**: rota `0.0.0.0/0` para o IGW
   - **Privada**: sem rota para internet

```bash
terraform apply -auto-approve
```

#### Associação de Subnets
1. Habilite os recursos de associação de tabelas de roteamento
2. Associe subnets públicas à tabela pública e privadas à tabela privada

```bash
terraform apply -auto-approve
```

### 3. Configuração de Grupos de Segurança para EC2 do Jenkins

1. No `main.tf` principal, habilite o módulo `grupo-de-segurança`
2. Regras de entrada permitirão tráfego nas portas:
   - **22** (SSH)
   - **80** (HTTP)
   - **443** (HTTPS)
   - **8080** (Jenkins)

```bash
terraform apply -auto-approve
```

### 4. Provisão da Instância EC2 e Instalação do Jenkins

#### Geração de Chaves SSH
```bash
ssh-keygen -f ~/.ssh/jenkins_demo
```

1. Copie o conteúdo da chave pública (`jenkins_demo.pub`)
2. Cole na variável `public_key` no arquivo `terraform.tfvars`

#### Configuração da Instância EC2
1. No `main.tf` principal, habilite o módulo `jenkins`
2. Configure:
   - AMI ID (imagem Ubuntu)
   - Tipo de instância (ex: `t2.medium`)
   - ID da subnet pública
   - IDs dos grupos de segurança

O `user_data` utilizará o script `jenkins-runner-script/installation-script.sh` para:
- Configurar JDK11
- Instalar Jenkins
- Instalar Terraform na instância EC2

```bash
terraform apply -auto-approve
```

#### Verificar e Configurar Jenkins
1. **Acesso Web**: `http://<IP_Público_EC2>:8080`

2. **SSH na instância**:
   ```bash
   chmod 400 ~/.ssh/jenkins_demo
   ssh -i ~/.ssh/jenkins_demo ubuntu@<IP_Público_EC2>
   ```

3. **Obter senha inicial**:
   ```bash
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   ```

4. **Configuração**:
   - Cole a senha no navegador
   - Instale plugins sugeridos
   - Crie usuário administrador

### 5. Configuração de Load Balancer, Route 53 e Certificate Manager

No `main.tf` principal, habilite os módulos:
- `load-balancer-target-group`
- `load-balancer`
- `zona-hospedagem`
- `certificate-manager`

#### Application Load Balancer (ALB)
- **Target Group**: configurado para instância EC2 do Jenkins na porta 8080
- **ALB**: listeners para HTTP (80) e HTTPS (443), redirecionando para HTTPS
- **Localização**: subnets públicas com grupos de segurança do EC2

#### Hosted Zone (Route 53)
- Utiliza Hosted Zone existente (ex: `dominio.org`)
- Cria registro A para `jenkins.dominio.org` apontando para o ALB
- **⚠️ Importante**: Atualize os servidores de nome (NS) no seu registrador de domínio

#### Certificate Manager (ACM)
- Solicita certificado SSL/TLS para `jenkins.dominio.org`
- Cria registro CNAME de validação automaticamente na Hosted Zone

```bash
terraform apply -auto-approve
```

## ✅ Verificação Final

Acesse `https://jenkins.dominio.org` no navegador (modo incógnito) para confirmar que tudo está funcionando corretamente.

## 📚 Recursos Adicionais

- [Documentação Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Documentação Jenkins](https://www.jenkins.io/doc/)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)

## 🤝 Contribuição

Contribuições são bem-vindas! Por favor, abra uma issue ou pull request para sugestões e melhorias.
