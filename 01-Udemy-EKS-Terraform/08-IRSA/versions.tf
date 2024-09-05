# Terraform Blocks
terraform {
  required_version = "~> 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.53.0"
    }
  }
  # Configuring its own S3 remote backend
  backend "s3" {
    bucket = "terraform-on-aws-eks-shubhams"
    key    = "dev/eks-irsa-demo/terraform.tfstate"
    region = "us-east-1"

    # For State Locking
    dynamodb_table = "dev-eks-irsa-demo"
  }
}