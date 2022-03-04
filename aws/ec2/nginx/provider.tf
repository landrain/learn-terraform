terraform {
  required_version = "= 1.0.8"

  backend "s3" {
    encrypt = true
    bucket  = "data-ops-terraform"
    region  = "us-east-2"
    key     = "aws/ec2/nginx.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
}
