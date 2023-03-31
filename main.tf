terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.60.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

variable "github_token" {
  type = string
}
output "token" {
  value = var.github_token
}

resource "aws_codebuild_source_credential" "example" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.github_token
}

resource "aws_codebuild_project" "example" {
  name = "fastapi-wiki-service"
  artifacts {

    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

  }

  service_role = "arn:aws:iam::247232402049:role/code-build-only-aws-service-role"

  source {
    type = "GITHUB"
    # buildspec           = "buildspec.yml"
    location            = "https://github.com/brettsteph/python-for-devops.git"
    git_clone_depth     = 1
    report_build_status = true
  }
  badge_enabled = true

  description   = "Build Wikipedia Service"
  build_timeout = "5"

  # source_version = "main"

  tags = {
    Environment = "Learning"
  }
}

resource "aws_codebuild_webhook" "example" {
  project_name = aws_codebuild_project.example.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    # filter {
    #   type    = "BASE_REF"
    #   pattern = "main"
    # }
  }
}