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

# variable "instance-1" {
#   description = "Instance type for one ec2"
#   default     = "t3.micro"
# }

# variable "application" {
#   description = "The department or application using this resource"
#   default     = "IMT"
#}