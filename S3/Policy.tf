data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "s3" {
    bucket = "<S3 Bucket Name>"
    tags = {
        Name = "<S3 Bucket Name>"
    }
}

resource "aws_s3_bucket_policy" "access" {
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.access.json
}

data "aws_iam_policy_document" "access" {
  statement {
    principals {
      type        = "*"
      # type = "AWS"
      identifiers = [ "*" ]
      # identifiers = [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" ]
    }
    actions = [
      "<Policy>"
    ]
    resources = [
      aws_s3_bucket.s3.arn,
      "${aws_s3_bucket.s3.arn}/*",
    ]
  }
}

output "s3" {
    value = aws_s3_bucket.s3.id
}

output "account_id" {
    value = data.aws_caller_identity.current.account_id
}