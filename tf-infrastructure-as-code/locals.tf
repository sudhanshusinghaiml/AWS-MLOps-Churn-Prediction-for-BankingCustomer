locals {
  code_build_service_role = "arn:aws:iam::959999474169:role/CodeBuild-Service-Role"
  code_commit_repo_name   = "banking_customer_churn_prediction_repo"
  code_commit_repo_url    = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/banking_customer_churn_prediction_repo"
  code_pipeline_role      = "arn:aws:iam::143176219551:role/service-role/AWSCodePipelineServiceRole-us-east-1-churn_pipeline"
  ecs_service_role        = "arn:aws:iam::959999474169:role/AWS-ECS-Service-Role"
  ecs_task_role           = "arn:aws:iam::959999474169:role/ECSTaskExecutionRole"
  vpc_id                  = "vpc-059d7278"
  tags = {
    application = "banking-customer-churn-application"
  }
}