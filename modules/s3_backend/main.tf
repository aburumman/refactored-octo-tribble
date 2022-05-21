terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.13.0"
    }
  }
}
provider "aws" {
  region  = "us-east-1"
  profile = "default"
  //access_key = var.access_key
  //secret_key = var.secret_key
}

/// First code block ends

// For the encryption of the state file and rotation of it's key
resource "aws_kms_key" "terraform-bucket-key" {
  description             = "This is the key used to encrypt the bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "key_alias" {
  name          = "alias/terraform-bucket-key"
  target_key_id = aws_kms_key.terraform-bucket-key.key_id
}


resource "aws_s3_bucket" "tfstate_file" {
  bucket = var.bucket_name
  acl    = "private"
  versioning {
    enabled = true
  }

  tags = {
    Name = "tfstate_bucket"
    Env  = var.env_tag
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.terraform-bucket-key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.tfstate_file.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform-state" {
  name           = "terraform-state"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}



