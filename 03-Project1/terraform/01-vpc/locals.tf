# Define Local Values in Terraform
locals {
    AssetID = "4054"
    environment = "Dev"
    purpose = "Created for learning/testing purposes"
    email    = "shubham.shubham@lexisnexis.com"
    owner = "FNU Shubham"
    username = "shubhams"
    resource_prefix = "${local.AssetID}-${local.username}"
    eks_cluster_name = "4054-shubhams-eks"
  
  common_tags = {
    AssetID = local.AssetID
    environment = local.environment
    purpose = local.purpose
    email    = local.email
    owner = local.owner
    username = local.username
  }
}