output "eip_address" {
  value       = aws_eip.this.public_ip
  description = "The public IP address connected to the web server EC2 instance."
}
