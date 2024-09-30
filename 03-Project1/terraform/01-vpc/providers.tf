terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "4054-shubhams-dev"
    key    = "dev/eks/terraform.tfstate"
    region = "us-east-1"

    # For State Locking
    dynamodb_table = "4054-shubhams-dev"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}