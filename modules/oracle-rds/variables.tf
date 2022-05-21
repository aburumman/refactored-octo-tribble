variable "name" {
  default = "IMT-ORACLE-RDS"
}

variable "db_security_group" {
    description = " "
 default = "db_security_group"
    
}
 

variable "db_user_name" {
    description = " "
    default = "imtuser"
}

variable "db_password" {
    description = " "
    default = "2qw3rw334w45"
}

variable "parameter_group_name" {
    description = " "
    default = "oracle-rds-group"
}

variable "engine_version" {
    description = " "
    default = "19.0.0.0.ru-2021-10.rur-2021-10.r1"
}

variable "license_model" {
    description = " "
    default = "bring-your-own-license"
}

variable "family" {
    description = " "
    default = "oracle-se2-19"
}


variable "db_instance_class" {
  default = "db.r5.2xlarge"
}
variable "db_test_instance" {
  default = "db.m4.large"
}

variable "back_up_retention_period" {
    default = "0"
}

variable "backup_window" {
    default = "03:00-05:00"
}

variable "maintenance_window" {
    type = string 
    default = "mon:05:00-mon:05:30"
}

variable "skip_final_snapshot" {
    type = bool
    default = "false"
}

variable "deletion_protection" {
    default = "false"
}

variable "allocated_storage" {
    description = ""
    default = "20"
}