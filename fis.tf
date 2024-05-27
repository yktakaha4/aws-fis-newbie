resource "aws_cloudwatch_log_group" "fis" {
  name              = "/${var.service}/fis"
}

resource "aws_iam_role" "fis" {
  name = "${var.service}-fis"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "fis.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
