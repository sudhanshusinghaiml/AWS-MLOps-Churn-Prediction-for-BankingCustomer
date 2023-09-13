resource "aws_codebuild_project" "banking_customer_churn_prediction" {

  badge_enabled          = false
  build_timeout          = "60"
  description            = "customer_churn_prediction_codebuild_project"
  concurrent_build_limit = 1
  name                   = "banking_customer_churn_prediction_project"
  source_version         = "ref/heads/master"
  queued_timeout         = 480
  service_role           = local.code_build_service_role


  artifacts {
    encryption_disabled    = false
    location               = ""
    name                   = "banking-churn-prediction-app"
    namespace_type         = "NONE"
    override_artifact_name = false
    packaging              = "ZIP"
    type                   = "S3"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      type  = "PLAINTEXT"
      value = "us-east-1"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      type  = "PLAINTEXT"
      value = ""
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      type  = "PLAINTEXT"
      value = "churn-application-repo"
    }

    environment_variable {
      name  = "IMAGE_TAG"
      type  = "PLAINTEXT"
      value = "latest"
    }

  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    type                = "CODECOMMIT"
    insecure_ssl        = false
    git_clone_depth     = 1
    report_build_status = false
    location            = local.code_commit_location

    git_submodules_config {
      fetch_submodules = false
    }
  }

  tags = local.tags

  depends_on = [
    aws_ecr_repository.banking_customer_churn_ecr_repo
  ]
}
