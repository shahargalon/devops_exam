output "instance_private_ip_1" {

  value = aws_instance.cassandra[0].private_ip
  depends_on = [
    aws_instance.cassandra
  ]
}

output "instance_private_ip_2" {

  value = aws_instance.cassandra[1].private_ip
  depends_on = [
    aws_instance.cassandra
  ]
}

output "instance_public_ip_1" {

  value = aws_instance.cassandra[0].public_ip
  depends_on = [
    aws_instance.cassandra
  ]
}

output "instance_puplic_ip_2" {

  value = aws_instance.cassandra[1].public_ip
  depends_on = [
    aws_instance.cassandra
  ]
}