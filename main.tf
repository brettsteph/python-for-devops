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
  region = var.aws_region
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
}


# Create ECR Repo
resource "aws_ecr_repository" "python-app" {
  name                 = "python-app"
  image_tag_mutability = "MUTABLE"

  force_delete = true

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "null_resource" "docker_build" {
  provisioner "local-exec" {    
    command = <<EOF
    aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
    docker build -t ${aws_ecr_repository.python-app.repository_url}:latest .
    docker push ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repository.python-app.name}:latest
    EOF
    # docker tag python-app:latest ${var.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/python-app:latest
  }
  depends_on = [
    aws_ecr_repository.python-app
  ]
}


resource "aws_codebuild_source_credential" "example" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.github_token
}

resource "aws_codebuild_project" "example" {
  name = "python-app-service"
  artifacts {

    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
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

# Because IAM role is no always available upon creation
resource "time_sleep" "waitrolecreate" {
  depends_on      = [aws_iam_role.apprunner]
  create_duration = "45s"
}

resource "aws_apprunner_service" "my-app-runner" {
  depends_on   = [time_sleep.waitrolecreate]
  service_name = "python-app-service"
  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner.arn
    }
    image_repository {
      image_configuration {
        port = 8080
      }
      image_identifier      = "${aws_ecr_repository.python-app.repository_url}:latest"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = true
  }
}

# Define the App Runner connection to the ECR repository
resource "aws_apprunner_connection" "python-app" {
  connection_name = "python-app-connection"
  provider_type = "GITHUB"
  tags = {
    Name = "python-app-connection"
  }
}

data "aws_iam_policy" "AWSAppRunnerServicePolicyForECRAccess" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

# Define trust policy IAM role for the App Runner service
resource "aws_iam_role" "apprunner" {
  name = "apprunner-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policy to the IAM role
resource "aws_iam_role_policy_attachment" "apprunner" {
  policy_arn = data.aws_iam_policy.AWSAppRunnerServicePolicyForECRAccess.arn
  role       = aws_iam_role.apprunner.name
}
