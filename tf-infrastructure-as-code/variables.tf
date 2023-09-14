variable "aws_region" {
  description = "AWS Regions where the resources will be created"
  # type = string
  default = "us-east-1"
}

variable "aws_profile" {
  description = "AWS Credentials Profile to be used for executing Terraform Scripts"
  default     = "aiml_user"
}

variable "aws_account_id" {
  description = "AWS Account ID to be used for executing Terraform Scripts"
  default     = "959999474169"
}