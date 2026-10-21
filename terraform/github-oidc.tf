# GitHub OIDC Provider
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]
}

# GitHub Actions 신뢰 정책
data "aws_iam_policy_document" "github_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:ZerojU@${var.github_owner_id}/aws-eks-gitops@${var.github_repo_id}:ref:refs/heads/main"
      ]
    }
  }
}

# GitHub Actions 전용 IAM Role
resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-github-actions-role"

  assume_role_policy = (
    data.aws_iam_policy_document.github_assume.json
  )
}

# ECR Push 권한
data "aws_iam_policy_document" "github_ecr_push" {

  # ECR 로그인 토큰 발급
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  # 지정한 ECR Repository에만 이미지 Push 허용
  statement {
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "ecr:BatchGetImage",
      "ecr:DescribeRepositories"
    ]

    resources = [
      data.aws_ecr_repository.project_app.arn
    ]
  }
}

# 기존 ECR Repository 조회
data "aws_ecr_repository" "project_app" {
  name = "aws-eks-gitops-project-app"
}

# IAM Policy 생성
resource "aws_iam_policy" "github_ecr_push" {
  name = "${var.project_name}-ecr-push-policy"

  policy = data.aws_iam_policy_document.github_ecr_push.json
}

# IAM Role에 Policy 연결
resource "aws_iam_role_policy_attachment" "github_ecr_push" {
  role = aws_iam_role.github_actions.name

  policy_arn = aws_iam_policy.github_ecr_push.arn
}