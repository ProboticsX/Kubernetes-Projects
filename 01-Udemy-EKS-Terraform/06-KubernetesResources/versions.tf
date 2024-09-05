# Terraform Blocks
terraform {
    required_version = "~> 1.5"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.53.0"
        }
        kubernetes = {
            source = "hashicorp/kubernetes"
            version = "~> 2.31.0"
        }
    }
}