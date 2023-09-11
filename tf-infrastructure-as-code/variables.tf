variable "aws_region" {
    description = "AWS Regions where the resources will be created"
    # type = string
    default = "us-east-1"
}

variable "aws_profile" {
    description = "AWS Credentials Profile to be used for executing Terraform Scripts"
    default = "rootuser" 
}