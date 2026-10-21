output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}

output "nat_eip" {
  value = aws_eip.nat.public_ip
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "eks_cluster_security_group_id" {
  value = (
    aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
  )
}

output "eks_node_group_name" {
  value = aws_eks_node_group.main.node_group_name
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node.arn
}

output "ecr_repository_url" {
  value = aws_ecr_repository.project_app.repository_url
}

output "github_actions_role_arn" {
  description = "IAM Role ARN for GitHub Actions OIDC"

  value = aws_iam_role.github_actions.arn
}