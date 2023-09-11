resource "aws_s3_bucket" "terraform-backend-banking-churn-prediction-app" {
  bucket = "terraform-backend-banking-churn-prediction-app"

  tags = local.tags
}

