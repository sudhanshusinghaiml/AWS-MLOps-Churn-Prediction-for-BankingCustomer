resource "aws_codepipeline" "banking_customer_churn_codepipeline" {
  name     = "banking_customer_churn_codepipeline"
  role_arn = local.code_pipeline_role
  tags     = local.tags

  artifact_store {
    location = aws_s3_bucket.terraform_codepipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        "BranchName"           = "develop"
        "OutputArtifactFormat" = "CODE_ZIP"
        "PollForSourceChanges" = "false"
        "RepositoryName"       = aws_codecommit_repository.banking_customer_churn_repo.repository_name
      }
      input_artifacts  = []
      name             = "Source"
      namespace        = "SourceVariables"
      output_artifacts = ["SourceArtifact"]
      owner            = "AWS"
      provider         = "CodeCommit"
      region           = "us-east-1"
      run_order        = 1
      version          = "1"
    }
  }
  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = aws_codebuild_project.banking_customer_churn_project.name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name             = "Build"
      namespace        = "BuildVariables"
      output_artifacts = ["BuildArtifact"]
      owner            = "AWS"
      provider         = "CodeBuild"
      region           = "us-east-1"
      run_order        = 1
      version          = "1"
    }
  }
  stage {
    name = "Deploy"

    action {
      category = "Deploy"
      configuration = {
        "ClusterName" = aws_ecs_cluster.banking_customer_churn_cluster.name
        "FileName"    = "imagedefinitions.json"
        "ServiceName" = aws_ecs_service.banking_customer_churn_service.name
      }
      input_artifacts  = ["BuildArtifact"]
      name             = "Deploy"
      namespace        = "DeployVariables"
      output_artifacts = []
      owner            = "AWS"
      provider         = "ECS"
      region           = "us-east-1"
      run_order        = 1
      version          = "1"
    }
  }

  depends_on = [aws_ecs_cluster.banking_customer_churn_cluster,
    aws_ecs_service.banking_customer_churn_service,
    aws_codecommit_repository.banking_customer_churn_repo,
    aws_codebuild_project.banking_customer_churn_project,
    aws_ecr_repository.banking_customer_churn_ecr_repo,
  aws_s3_bucket.terraform_codepipeline]
}