resource "aws_cloudwatch_log_group" "fis" {
  name = "/${var.service}/fis"
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

resource "aws_iam_role_policy_attachment" "fis_ec2" {
  role       = aws_iam_role.fis.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSFaultInjectionSimulatorEC2Access"
}

resource "aws_iam_role_policy_attachment" "fis_network" {
  role       = aws_iam_role.fis.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSFaultInjectionSimulatorNetworkAccess"
}

resource "aws_iam_role_policy_attachment" "fis_rds" {
  role       = aws_iam_role.fis.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSFaultInjectionSimulatorRDSAccess"
}

# resource "aws_iam_policy" "fis_custom" {
#   name = "${var.service}-fis-custom"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Deny"
#         Action   = "*"
#         Resource = "*"
#         Condition = {
#           "StringNotEqualsIfExists" = {
#             "aws:ResourceTag/fis/service" = "aws-fis-newbie"
#           }
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "fis_custom" {
#   role       = aws_iam_role.fis.name
#   policy_arn = aws_iam_policy.fis_custom.arn
# }
