
// Fisrt Code block: Comment it out on first run

/**
terraform {
  backend "s3" {
    bucket         = "tketfstatebucket"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "alias/terraform-bucket-key"
    dynamodb_table = "terraform-state"
  }

}

**/

