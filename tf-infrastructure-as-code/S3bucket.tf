resource "aws_s3_bucket" "terraform_backend" {
  bucket = "terraform-backend-15091025"
  tags   = local.tags
}

resource "aws_s3_bucket" "terrform_codebuild" {
  bucket = "terrform-codebuild-15091025"
  tags   = local.tags
}

resource "aws_s3_bucket" "terraform_codepipeline" {
  bucket = "terraform-codepipeline-15091025"
  tags   = local.tags
}
