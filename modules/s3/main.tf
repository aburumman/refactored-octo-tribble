resource "aws_s3_bucket" "main_bucket" {
  bucket = var.s3_bucket
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "main_bucket" {
  bucket = aws_s3_bucket.main_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}