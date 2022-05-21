
module "vpc" {
  //source = "./modules/vpc"
  source = "../vpc"

}


resource "aws_security_group" "second" {
  name        = var.db_security_group
  description = "Allow Neccessary ports for Oracle RDS"
  vpc_id      = module.vpc.vpc_id


  # ingress
  ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    description = "Oracle access from within VPC"
    cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
   from_port = "0"
   protocol = "-1"
   to_port = "0"
   cidr_blocks = ["0.0.0.0/0"]
 }
}




resource "aws_db_instance" "this" {
  identifier     = "imtprod"
  instance_class = var.db_test_instance
  allocated_storage    = var.allocated_storage
  username             = var.db_user_name
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.this.name
  //db_subnet_group_name   = module.vpc.second_subnet
  //vpc_security_group_ids = [aws_security_group.second.id]
  //parameter_group_name   = aws_db_parameter_group.this
  //parameter_group_name = "default.oracle-ee-12.1"
  //parameter_group_name = "default.oracle-ee-19"
  parameter_group_name = var.parameter_group_name # Can be any name
  skip_final_snapshot  = true
  storage_encrypted = false
  //engine = "oracle-ee"
  engine = "oracle-se2"
  //character_set_name = "WE8MSWIN1252"  # Optional: default is set (AL32UTF8)
  availability_zone   = "us-east-1a"
  publicly_accessible = false
  //multi_az = false
  //engine_version       = "12.1.0.2.v24"
  engine_version = var.engine_version //"19.0.0.0.ru-2021-10.rur-2021-10.r1"
  //family               = "oracle-ee-19.0" # DB parameter group
  #license_model        = "license-included"
  license_model = var.license_model
  //apply_immediately           = true
  //backup_retention_period = var.backup_retention_period
  //backup_window           = var.backup_window
  //maintenance_window      = var.maintenance_window
  //skip_final_snapshot     = var.skip_final_snapshot
  //copy_tags_to_snapshot   = var.copy_tags_to_snapshot
  deletion_protection     = var.deletion_protection
  //allocated_storage     = 20
  //max_allocated_storage = 100

  # Make sure that database name is capitalized, otherwise RDS will try to recreate RDS instance every time
  port = 1521
  depends_on = [aws_db_parameter_group.this]
}

resource "aws_db_subnet_group" "this" {
  //name = "oracle-rds2"
  name = var.parameter_group_name
  //db_subnet_group_name = module.vpc.db-subnet
  subnet_ids = [module.vpc.second_subnet, module.vpc.third_subnet]

  tags = {

  }
}





resource "aws_db_parameter_group" "this" {
  name = "oracle-rds-group"
  //name = "oracle-rds2"
  //family               = "oracle-ee-19.0"
  //family               = "oracle-ee-12.1"
  //family               = "oracle-se2"
  //family               = "oracle-se2-cdb"
  //family = "oracle-ee"
  //oracle-se2-cdb
  //family = "oracle-ee-19" # Other options oracle-se2-cdb-19
  family = var.family // "oracle-se2-19"
  // family = "oracle-se2-cdb-19"

  parameter {
    name  = "open_cursors"
    value = "1500"
  }

  #   parameter {
  #       name = "SCOPE"
  #       value = "BOTH"
  #   }

  parameter {
    name  = "CURSOR_SHARING"
    value = "FORCE"
  }

  parameter {
    name  = "NLS_LENGTH_SEMANTICS"
    value = "CHAR"
  }

    parameter {
    name = "sqlnetora.sqlnet.allowed_logon_version_server"
  #       name = "SQLNET.ALLOWED_LOGON_VERSION_SERVER"
        value = "8"
   }
}

