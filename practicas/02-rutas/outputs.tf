output "vpc_de_la_01" {
  value = data.terraform_remote_state.ec2.outputs.vpc_id

}
