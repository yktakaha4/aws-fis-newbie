# resource "random_string" "db_password" {
#   length  = 32
#   special = true
# }

# resource "aws_security_group" "db" {
#   name   = "${var.service}-db"
#   vpc_id = aws_vpc.main.id
# }

# resource "aws_db_subnet_group" "main" {
#   name = "${var.service}-main"
#   subnet_ids = [
#     aws_subnet.private_1a.id,
#     aws_subnet.private_1c.id
#   ]
# }

# resource "aws_db_instance" "main" {
#   identifier             = "${var.service}-main"
#   allocated_storage      = 10
#   engine                 = "postgres"
#   engine_version         = "16.2"
#   instance_class         = "db.t3.micro"
#   db_name                = var.service
#   username               = var.service
#   password               = random_string.db_password.result
#   vpc_security_group_ids = [aws_security_group.db.id]
#   db_subnet_group_name   = aws_db_subnet_group.main.name
#   storage_encrypted      = true
#   skip_final_snapshot    = true
# }
