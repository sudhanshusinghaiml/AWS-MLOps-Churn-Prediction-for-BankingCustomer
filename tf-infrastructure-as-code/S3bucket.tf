resource "aws_s3_bucket" "terraform_backend" {
  bucket = "terraform-backend-18091923"
  tags   = local.tags
}

resource "aws_s3_bucket" "terrform_codebuild" {
  bucket = "terrform-codebuild-18091923"
  tags   = local.tags
}

resource "aws_s3_bucket" "terraform_codepipeline" {
  bucket = "terraform-codepipeline-18091923"
  tags   = local.tags
}