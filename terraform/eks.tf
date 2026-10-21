resource "aws_eks_cluster" "main" {
  name = "${var.project_name}-cluster"

  role_arn = aws_iam_role.eks_cluster.arn

  version = "1.36"

  access_config {
    authentication_mode = "API"

    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids = aws_subnet.private[*].id

    endpoint_private_access = true
    endpoint_public_access  = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster
  ]

  tags = {
    Name = "${var.project_name}-cluster"
  }
}