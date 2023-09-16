resource "aws_codepipeline" "banking_customer_churn_codepipeline" {
    name     = "banking_customer_churn_codepipeline"
    role_arn = "arn:aws:iam::959999474169:role/codepipeline_service_role"
    tags     = local.tags

    artifact_store {
        location = "codepipeline-us-east-1-385762376893"
        type     = "S3"
    }

    stage {
        name = "Source"

        action {
            category         = "Source"
            configuration    = {
                "BranchName"           = "develop"
                "OutputArtifactFormat" = "CODE_ZIP"
                "PollForSourceChanges" = "false"
                "RepositoryName"       = aws_ecr_repository.banking_customer_churn_ecr_repo.name
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
            category         = "Build"
            configuration    = {
                "ProjectName" = aws_codebuild_project.banking_customer_churn_project.name
            }
            input_artifacts  = [
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
            category         = "Deploy"
            configuration    = {
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
}