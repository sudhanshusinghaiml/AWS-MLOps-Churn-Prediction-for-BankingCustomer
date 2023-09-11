resource "aws_ecr_repository" "churn-prediction-repo" {
  name                 = "churn-prediction-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}