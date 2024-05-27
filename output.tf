output "web_1_url" {
  value = "http://${aws_instance.web_1.public_ip}:5000"
}

output "web_2_url" {
  value = "http://${aws_instance.web_2.public_ip}:5000"
}

output "alb_url" {
  value = "http://${aws_lb.main.dns_name}"
}
