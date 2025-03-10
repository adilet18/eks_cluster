output "web_public_ip" {
  value      = aws_eip.web_eip[0].public_ip
  depends_on = [aws_eip.web_eip]
}

output "web_public_dns" {
  value      = aws_eip.web_eip[0].public_dns
  depends_on = [aws_eip.web_eip]
}

output "rds_endpoint" {
  value = aws_db_instance.rds.address
}

output "database_port" {
  value = aws_db_instance.rds.port
}

output "private_key_pem" {
  value     = tls_private_key.my_key_pair.private_key_pem
  sensitive = true
}
