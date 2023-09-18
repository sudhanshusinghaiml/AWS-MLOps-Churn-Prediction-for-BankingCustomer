resource "aws_codebuild_project" "banking_customer_churn_project" {
  badge_enabled          = false
  build_timeout          = 60
  concurrent_build_limit = 1
  description            = "Banking Customer Churn Prediction Code Build Project"
  encryption_key         = local.s3_encryption_key
  name                   = "banking_customer_churn_project"
  project_visibility     = "PRIVATE"
  queued_timeout         = 480
  service_role           = local.code_build_service_role
  source_version         = "refs/heads/develop"
  tags                   = local.tags
  tags_all               = local.tags

  artifacts {
    encryption_disabled    = true
    location               = aws_s3_bucket.terrform_codebuild.bucket
    name                   = "banking_customer_churn_project"
    namespace_type         = "BUILD_ID"
    override_artifact_name = true
    packaging              = "ZIP"
    path                   = "codebuild_artifacts_output/"
    type                   = "S3"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      type  = "PLAINTEXT"
      value = var.aws_region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      type  = "PLAINTEXT"
      value = var.aws_account_id
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      type  = "PLAINTEXT"
      value = aws_ecr_repository.banking_customer_churn_ecr_repo.name
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
    buildspec           = "buildspec.yml"
    git_clone_depth     = 1
    insecure_ssl        = false
    location            = aws_codecommit_repository.banking_customer_churn_repo.clone_url_http
    report_build_status = false
    type                = "CODECOMMIT"

    git_submodules_config {
      fetch_submodules = false
    }
  }

  depends_on = [aws_ecr_repository.banking_customer_churn_ecr_repo]

}