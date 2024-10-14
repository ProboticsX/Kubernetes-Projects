data "aws_vpc" "vpc_data" {
  id = data.terraform_remote_state.vpc.outputs.vpc_id
}