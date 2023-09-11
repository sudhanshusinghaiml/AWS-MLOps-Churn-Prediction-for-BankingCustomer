resource "aws_codecommit_repository" "banking-churn-prediction-repo" {
  repository_name = "banking-churn-prediction-repo"
  description     = "This is the code repository for Churn Prediction for Banking Customer"
}

output "churn_repo_clone_url_http" {
  value       = aws_codecommit_repository.banking-churn-prediction-repo.clone_url_http
  description = "The private IP address of the main server instance."
}

output "churn_repo_clone_url_ssh" {
  value       = aws_codecommit_repository.banking-churn-prediction-repo.clone_url_ssh
  description = "The private IP address of the main server instance."
}