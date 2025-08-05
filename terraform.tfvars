bucket_name = "dev-proj-1-jenkins-remote-state-bucket-123456"

vpc_cidr             = "11.0.0.0/16"
vpc_name             = "projeto-jenkins-sa-east-1"
cidr_public_subnet   = ["11.0.1.0/24", "11.0.2.0/24"]
cidr_private_subnet  = ["11.0.3.0/24", "11.0.4.0/24"]
eu_availability_zone = ["sa-east-1a", "sa-east-1b"]

public_key = "" # colocar a chave aqui
ec2_ami_id = "ami-0694d931cee176e7d"