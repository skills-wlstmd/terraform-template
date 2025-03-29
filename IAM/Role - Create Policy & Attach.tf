resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "<Service Name>.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "<env>-role"
  }
}

resource "aws_iam_policy" "test_policy" {
  name        = "test_policy"
  description = "A test policy for the test_role"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.test_role.name
  policy_arn = aws_iam_policy.test_policy.arn
}

output "iam-role" {
  value = aws_iam_role.role.name
}
