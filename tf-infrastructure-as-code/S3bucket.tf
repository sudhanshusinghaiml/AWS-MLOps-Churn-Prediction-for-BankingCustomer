resource "aws_s3_bucket" "terraform-backend-banking-churn-prediction-app" {
  bucket = "terraform-backend-banking-churn-prediction-app"
  tags   = local.tags
}

resource "aws_s3_object" "codebuild" {
  bucket = aws_s3_bucket.terraform-backend-banking-churn-prediction-app.id
  key    = "banking-churn-prediction-app/codebuild-artifacts-output/"
}

# resource "aws_s3_object" "codepipeline" {
#   bucket = aws_s3_bucket.terraform-backend-banking-churn-prediction-app.id
#   key    = "banking-churn-prediction-app/codepipeline-artifacts-output/"
# }
