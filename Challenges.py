"""
The Python "AttributeError: 'tuple' object has no attribute" occurs when we access an attribute that doesn't exist on a tuple.

"""
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
# ======================================================================================
# Other Terraform Commands
# ======================================================================================
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
    1. Build failed due to below errors -  YAML_FILE_ERROR Message: Invalid buildspec phase name: artifacts.
       - Corrected the Identation in the buildspec.yml file.
    
    2. An error occurred (AccessDeniedException) when calling the GetAuthorizationToken operation: 
       User: arn:aws:sts::XXXXXXXX:assumed-role/banking-customer-churn-codebuild-service-role/
       AWSCodeBuild-886ba1b7-1274-498e-a6f2-83f325dac60a is not authorized to perform: ecr:GetAuthorizationToken 
       on resource: * because no identity-based policy allows the ecr:GetAuthorizationToken action
       
       - Attached AmazonElasticContainerRegistryPublicPowerUser policy to the service role -> banking-customer-churn-codebuild-service-role
"""

application_url = "http://banking-customer-churn-alb-761037886.us-east-1.elb.amazonaws.com"
churn_repo_clone_url_http = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/banking_customer_churn_repo"
churn_repo_clone_url_ssh = "ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/banking_customer_churn_repo"

code_pipeline_service_role = "arn:aws:iam::959999474169:role/codepipeline_service_role"


import aws_codedeploy_app.banking-customer-churn-app banking-customer-churn-app

terraform import aws_codedeploy_deployment_group.banking-customer-churn-app-deploy banking-customer-churn-app:banking-customer-churn-app-deploy
"""

"""
    Testing the application in local using docker image
    
    docker system prune --volumes -a -f 
    
    docker build -t banking-churn-prediction-image . 

    docker run -dp 5000:5000 bankingcustomerchurnprediction
        
    docker logs [container id]
    
    docker ps -a
    
    docker stop 
"""


https://git-codecommit.us-east-1.amazonaws.com/v1/repos/banking_customer_churn_repo