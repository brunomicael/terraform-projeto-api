terraform {
  backend "s3" {
    bucket = "projeto-jenkins-remote-state"
    key    = "projeto/jenkins/terraform.tfstate"
    region = "sa-east-1"
  }
}