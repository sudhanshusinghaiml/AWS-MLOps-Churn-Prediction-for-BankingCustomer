locals {
  code_build_service_role = "arn:aws:iam::959999474169:role/service-role/banking-customer-churn-codebuild-service-role"
  code_pipeline_role      = "arn:aws:iam::959999474169:role/service-role/AWSCodePipelineServiceRole-us-east-1-churn_pipeline"
  ecs_service_role        = "arn:aws:iam::959999474169:role/AWS-ECS-Service-Role"
  ecs_task_role           = "arn:aws:iam::959999474169:role/ECSTaskExecutionRole"
  vpc_id                  = "vpc-006a117f95111f259"
  security_groups         = "sg-039a2f03d65350909"
  subnets = [
    "subnet-0911024c785757682",
    "subnet-05189d7bb4490ce61",
    "subnet-0d1692e706f5ba52a",
    "subnet-03fdb4e1e28453ff1",
    "subnet-091adbb37f77e64a7",
    "subnet-0709706a350f530e9"
  ]
  tags = {
    application = "banking-customer-churn-application"
  }
}