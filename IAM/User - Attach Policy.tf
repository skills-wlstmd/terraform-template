resource "aws_iam_user" "user" {
  name = "<User Name>"
}

resource "aws_iam_policy" "policy" {
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

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.policy.arn
}

output "iam-user" {
  value = aws_iam_user.user.name
}