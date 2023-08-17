output "vpc_id" {
  value = aws_vpc.infnet-lab.id
}

output "private_subnet_ids" {
  value = aws_subnet.infnet-lab-private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.infnet-lab-public[*].id
}