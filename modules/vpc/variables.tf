/**
variable "access_key" {
    description = "AWS access key "
}
variable "secret_key" {
    description = "AWS secret access key"

}
**/
variable "name" {
  description = "Name of resource"
  type        = string
  default     = "IMT-dev"
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

variable "application" {
  description = "The department or application using this resource"
  default     = "IMT"
}

variable "zone" {
    description = "VPC endpoint AZ"
    default = "us-east-2"
}