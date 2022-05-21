/**
module "s3_backend" {
  source = "./modules/s3_backend"
}

**/

module "ec2_iam" {
  source = "./modules/ec2_iam"
}


module "ec2" {
  source = "./modules/ec2"
}




module "vpc" {
  source = "./modules/vpc"
}




module "oracle-rds" {
  source = "./modules/oracle-rds"
}

