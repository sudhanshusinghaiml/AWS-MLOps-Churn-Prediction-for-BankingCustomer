resource "aws_ecr_repository" "banking_customer_churn_ecr_repo" {
  name                 = "banking_customer_churn_ecr_repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}