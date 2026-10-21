# EKS Cluster가 사용할 IAM Role

data "aws_iam_policy_document" "eks_cluster_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "eks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "eks_cluster" {
  name = "${var.project_name}-cluster-role"

  assume_role_policy = (
    data.aws_iam_policy_document.eks_cluster_assume.json
  )
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  role = aws_iam_role.eks_cluster.name

  policy_arn = (
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  )
}


# EC2 Worker Node가 사용할 IAM Role

data "aws_iam_policy_document" "eks_node_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "eks_node" {
  name = "${var.project_name}-node-role"

  assume_role_policy = (
    data.aws_iam_policy_document.eks_node_assume.json
  )
}

resource "aws_iam_role_policy_attachment" "eks_node_worker" {
  role = aws_iam_role.eks_node.name

  policy_arn = (
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  )
}

resource "aws_iam_role_policy_attachment" "eks_node_ecr" {
  role = aws_iam_role.eks_node.name

  policy_arn = (
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  )
}

resource "aws_iam_role_policy_attachment" "eks_node_cni" {
  role = aws_iam_role.eks_node.name

  policy_arn = (
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  )
}