provider "aws" {
  region = local.region
}

terraform {
  backend "s3" {
    bucket = "cicd-onyeka"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}