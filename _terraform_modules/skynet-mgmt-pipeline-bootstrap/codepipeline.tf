resource "aws_codestarconnections_connection" "this" {
  name          = local.codepipeline_prefix
  provider_type = "GitHub"
}

resource "aws_codepipeline" "this" {
  name           = "${local.prefix}-mgmt-pipeline"
  role_arn       = aws_iam_role.codepipeline_role.arn
  pipeline_type  = "V2"
  execution_mode = "QUEUED"

  artifact_store {
    location = aws_s3_bucket.codepipeline.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.this.arn
        FullRepositoryId     = "arturo-ai/skynet-on-demand-iac"
        BranchName           = var.skynet_on_demand_iac_repo_branch
        DetectChanges        = "false"
        OutputArtifactFormat = "CODE_ZIP"
      }

      name             = "Source-skynet-on-demand-iac"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output_skynet_on_demand_iac"]
      region           = local.region
      run_order        = "1"
    }
  }

  stage {
    name = "Plan"

    action {
      category = "Build"

      configuration = {
        ProjectName = aws_codebuild_project.tf_plan.name
      }

      name             = "Plan"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output_skynet_on_demand_iac"]
      output_artifacts = ["plan_output_skynet_on_demand_iac"]
      region           = local.region
      run_order        = "1"
    }

    action {
      category = "Approval"

      configuration = {
        CustomData = "Press \"View details\" button on the \"Plan\" step to review changes."
      }

      name      = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      run_order = 2
    }
  }

  stage {
    name = "Apply"

    action {
      category = "Build"

      configuration = {
        ProjectName   = aws_codebuild_project.tf_apply.name
        PrimarySource = "source_output_skynet_on_demand_iac"
      }

      name             = "Apply"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output_skynet_on_demand_iac", "plan_output_skynet_on_demand_iac"]
      output_artifacts = ["apply_output_skynet_on_demand_iac"]
      region           = local.region
      run_order        = "1"
    }
  }
}
