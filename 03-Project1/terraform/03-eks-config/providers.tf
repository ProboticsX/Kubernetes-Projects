terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "4054-shubhams-eks"
    key    = "dev/eks-config/terraform.tfstate"
    region = "us-east-1"

    # For State Locking
    dynamodb_table = "4054-shubhams-dev"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host =   data.terraform_remote_state.eks_cluster.outputs.cluster_endpoint
  cluster_ca_certificate  = base64decode(data.terraform_remote_state.eks_cluster.outputs.cluster_certificate_authority_data)
  token = data.aws_eks_cluster_auth.cluster.token
}