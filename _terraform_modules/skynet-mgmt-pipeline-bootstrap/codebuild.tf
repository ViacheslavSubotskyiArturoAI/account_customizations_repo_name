resource "aws_codebuild_project" "tf_plan" {
  name               = local.codebuild_project.tf_plan
  service_role       = aws_iam_role.codebuild_skynet_mgmt_pipeline_role.arn
  project_visibility = "PRIVATE"
  queued_timeout     = "480"

  artifacts {
    encryption_disabled    = "false"
    override_artifact_name = "false"
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "false"
    type                        = "LINUX_CONTAINER"

    environment_variable {
      name  = "TF_SKYNET_MGMT_PIPELINE_WORK_DIR"
      value = local.codebuild_mgmt_pipeline_work_dir
    }
  }

  source {
    buildspec           = file("${path.module}/buildspec-tf-plan.yaml")
    insecure_ssl        = "false"
    report_build_status = "false"
    type                = "CODEPIPELINE"
  }

  depends_on = [aws_cloudwatch_log_group.codebuild]
}

resource "aws_codebuild_project" "tf_apply" {
  name               = local.codebuild_project.tf_apply
  service_role       = aws_iam_role.codebuild_skynet_mgmt_pipeline_role.arn
  project_visibility = "PRIVATE"
  queued_timeout     = "480"

  artifacts {
    encryption_disabled    = "false"
    override_artifact_name = "false"
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = "false"
    type                        = "LINUX_CONTAINER"

    environment_variable {
      name  = "TF_SKYNET_MGMT_PIPELINE_WORK_DIR"
      value = local.codebuild_mgmt_pipeline_work_dir
    }
  }

  source {
    buildspec           = file("${path.module}/buildspec-tf-apply.yaml")
    insecure_ssl        = "false"
    report_build_status = "false"
    type                = "CODEPIPELINE"
  }

  depends_on = [aws_cloudwatch_log_group.codebuild]
}
