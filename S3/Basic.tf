resource "aws_s3_bucket" "s3" {
    bucket = "<S3 Bucket Name>"

    tags = {
        Name = "<S3 Bucket Name>"
    } 
}

output "s3" {
    value = aws_s3_bucket.s3.id
}