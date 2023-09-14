"""
The Python "AttributeError: 'tuple' object has no attribute" occurs when we access an attribute that doesn't exist on a tuple.

"""

churn_repo_clone_url_http = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/banking_customer_churn_prediction_repo"
churn_repo_clone_url_ssh = "ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/banking_customer_churn_prediction_repo"

# ==============================================

"""
How to use Import in Terraform 
    terrform import 
    terraform import aws_codebuild_project.banking_customer_churn_prediction_project banking_customer_churn_prediction_project

output- 
    resource "aws_codebuild_project" "banking_customer_churn_prediction_project" {
    # (resource arguments)
    }
copy the output in a file and run the same import command again.

teraform plan --> it shows that "1 to destroy"

terraform show --> It will show the list of all the resources that we have created in AWS with all the parameters.

We can copy the details of code build and save it for our reference.

"""

# Other Terraform Commands

"""
Terraform Commands-
    terraform console -> will get you into terraform CLI where we can test out our codes
        -> aws_codecommit_repository.banking_customer_churn_prediction_repo
        This will give all the details related to the particular resources
        
    terraform init
    terraform plan
    terraform apply
    terraform fmt
    terraform state list
        aws_codecommit_repository.banking_customer_churn_prediction_repo
        aws_ecr_repository.banking_customer_churn_ecr_repo
        aws_s3_bucket.terraform-backend-banking-churn-prediction-app
        
    terraform apply -target="aws_ecr_repository.banking_customer_churn_ecr_repo" 
        --> it will only create this resources
        --> we can also add multiple target resources
    
"""

"""
