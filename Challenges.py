"""
The Python "AttributeError: 'tuple' object has no attribute" occurs when we access an attribute that doesn't exist on a tuple.

"""

churn_repo_clone_url_http = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/banking_customer_churn_prediction_repo"
churn_repo_clone_url_ssh = "ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/banking_customer_churn_prediction_repo"

# ==============================================
Terraform Commands-

terraform init
terraform plan
terraform apply

terraform fmt

terraform state list
    aws_codecommit_repository.banking_customer_churn_prediction_repo
    aws_ecr_repository.banking_customer_churn_ecr_repo
    aws_s3_bucket.terraform-backend-banking-churn-prediction-app

terrform import 
    terraform import aws_codebuild_project.banking_customer_churn_prediction banking_customer_churn_prediction
    
terraform show

    