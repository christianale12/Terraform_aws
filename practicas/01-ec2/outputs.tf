output "vpc_id" { value = aws_vpc.lab.id }
output "subnet_id" { value = aws_subnet.lab.id }
output "sg_id" { value = aws_security_group.lab.id }
output "maquina_id" { value = aws_instance.maquina.id }