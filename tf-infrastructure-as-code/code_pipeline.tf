# resource "aws_codepipeline" "banking_customer_churn_codepipeline" {
#   name     = "banking_customer_churn_codepipeline"
#   role_arn = aws_iam_role.codepipeline_service_role.arn
#   tags = local.tags
# 
#   artifact_store {
#     location = aws_codebuild_project.banking_customer_churn_project.artifacts[0].location
#     type     = "S3"
#   }
# 
#   stage {
#     name = "Source"
# 
#     action {
#       name             = "Source"
#       category         = "Source"
#       owner            = "AWS"
#       provider         = "CodeCommit"
#       region           = "us-east-1"
#       version          = "1"
#       output_artifacts = ["SourceArtifact"]
# 
#       configuration = {
#         RepositoryName   = aws_codecommit_repository.banking_customer_churn_repo.repository_name
#         BranchName       = "develop"
#         OutputArtifactFormat = "CODE_ZIP"
#         PollForSourceChanges = "false"
#       }
#     }
#   }
# 
#   stage {
#     name = "Build"
# 
#     action {
#       name             = "Build"
#       category         = "Build"
#       owner            = "AWS"
#       provider         = "CodeBuild"
#       input_artifacts  = ["SourceArtifact"]
#       output_artifacts = ["BuildArtifact"]
#       region           = "us-east-1"
#       version          = "1"
# 
#       configuration = {
#         ProjectName = aws_codebuild_project.banking_customer_churn_project.name
#       }
#     }
#   }
# 
#   stage {
#     name = "Deploy"
# 
#     action {
#       name             = "Deploy"
#       category         = "Deploy"
#       owner            = "AWS"
#       provider         = "ECS"
#       input_artifacts  = ["BuildArtifact"]
#       output_artifacts = []
#       region           = "us-east-1"
#       version          = "1"
# 
#       configuration = {
#         ClusterName = aws_ecs_cluster.banking_customer_churn_cluster.name
#         ServiceName = aws_ecs_service.banking_customer_churn_service.name
#       }
#     }
#   }
# }
# 
# 
# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"
# 
#     principals {
#       type        = "Service"
#       identifiers = ["codepipeline.amazonaws.com"]
#     }
# 
#     actions = ["sts:AssumeRole"]
#   }
# }
# 
# resource "aws_iam_role" "codepipeline_service_role" {
#   name               = "codepipeline_service_role"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }
# 
# output "code_pipeline_service_role" {
#   value = aws_iam_role.codepipeline_service_role.arn
#   description = "CodePipeline Service Role"
# }