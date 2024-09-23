# Define Local Values in Terraform
locals {
    id = "4054"
    environment = "Dev"
    purpose = "Created for learning/testing purposes"
    email    = "shubham.shubham@lexisnexis.com"
    owner = "FNU Shubham"
    username = "shubhams"
    resource_prefix = "${local.id}-${local.username}"
  
  common_tags = {
    id = local.id
    environment = local.environment
    purpose = local.purpose
    email    = local.email
    owner = local.owner
    username = local.username
  }
}