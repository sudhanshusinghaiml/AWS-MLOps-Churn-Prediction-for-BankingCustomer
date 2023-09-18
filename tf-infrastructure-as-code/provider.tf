terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.16.1"
    }
  }
}

provider "aws" {
  # Configuration options
  region                   = var.aws_region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = var.aws_profile
}

terraform {
  backend "s3" {
    bucket = "terraform-backend-18091923"
    key    = "banking-customer-churn-prediction-backend/terraform.tfstate"
    region = "us-east-1"
  }
}