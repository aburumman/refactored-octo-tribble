/**
variable "access_key" {
    description = "AWS access key "
}
variable "secret_key" {
    description = "AWS secret access key"

}
**/
variable "bucket_name" {
  description = "Backend s3 bucket name"
  type        = string
  default     = "tketfstatebucket"
}

variable "instance_type" {
  description = "change the instance type on execution in prodution"
  default     = "t2.micro"
  // default = "r5.2xlarge"
}

variable "bastion_instance_type" {
    description = " "
    default = "t2.micro"
}

variable "bastion_private_ip" {
    description = " "
    default = "10.0.4.20"
}

variable "main_instance_ip" {
    description = " "
    default = "10.0.1.20"
}

variable "main_security_group" {
    description = " "
    default = "Main-SG"
}


variable "volume_size" {
  description = "for test is 10"
  default     = "10"
  //default = "500"
}

variable "region" {
  description = "AWS Region for s3 bucket"
  type        = string
  default     = "us-east-1"
}

variable "env_tag" {
  description = "Envivronment tag"
  type        = string
  default     = "Prod"
}

variable "instance-1" {
  description = "Instance type for main ec2"
  default     = "t3.micro"
}

variable "application" {
  description = "The department or application using this resource"
  default     = "IMT"
}

variable "instance_key" {
  default = "IMT_key"
}