resource "aws_security_group" "web" {
  name   = "${var.service}-web"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "web_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.client_ip_v4_address}/32"]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "web_ingress_http" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  cidr_blocks       = ["${var.client_ip_v4_address}/32"]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "web_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}

resource "aws_instance" "web_1" {
  ami           = var.ec2_ami_id
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = var.ec2_key_name
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/templates/user_data.bash", {
    postgres_host     = aws_db_instance.main.address
    postgres_port     = aws_db_instance.main.port
    postgres_db       = aws_db_instance.main.db_name
    postgres_user     = aws_db_instance.main.username
    postgres_password = random_string.db_password.result
  })

  root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    delete_on_termination = true

    tags = {
      Name = "${var.service}-web-1"
    }
  }

  tags = {
    Name = "${var.service}-web-1"
  }
}
