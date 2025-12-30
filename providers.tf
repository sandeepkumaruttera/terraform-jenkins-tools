terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0.0"
    }
  }
  backend "s3" {
    bucket = "draws26s"
    key    = "terraform-jenkins"
    region = "us-east-1"
    dynamodb_table = "draws26s-dev"
  }
}

#provide authentication here
provider "aws" {
  region = "us-east-1"
}
