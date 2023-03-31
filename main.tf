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

    # environment_variable {
    #   name  = "SOME_KEY1"
    #   value = "SOME_VALUE1"
    # }

    # environment_variable {
    #   name  = "SOME_KEY2"
    #   value = "SOME_VALUE2"
    #   type  = "PARAMETER_STORE"
    # }
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

  #   source {
  #     type            = "GITHUB"
  #     location        = "https://github.com/mitchellh/packer.git"
  #     git_clone_depth = 1

  #     git_submodules_config {
  #       fetch_submodules = true
  #     }
  #   }

  #   logs_config {
  #     cloudwatch_logs {
  #       group_name  = "log-group"
  #       stream_name = "log-stream"
  #     }

  #     s3_logs {
  #       status   = "ENABLED"
  #       location = "${aws_s3_bucket.example.id}/build-log"
  #     }
  #   }  

  description   = "Build Wikipedia Service"
  build_timeout = "5"

  # source_version = "main"

  #   vpc_config {
  #     vpc_id = aws_vpc.example.id

  #     subnets = [
  #       aws_subnet.example1.id,
  #       aws_subnet.example2.id,
  #     ]

  #     security_group_ids = [
  #       aws_security_group.example1.id,
  #       aws_security_group.example2.id,
  #     ]
  #   }

  tags = {
    Environment = "Test"
  }
}
