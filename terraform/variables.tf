variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "Project resource prefix"
  type        = string
  default     = "aws-eks-gitops"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)

  validation {
    condition = (
      length(var.availability_zones) == 2 &&
      length(distinct(var.availability_zones)) == 2
    )
    error_message = "Specify two different AZs."
  }
}

variable "github_owner_id" {
  description = "GitHub owner numeric ID"
  type        = string
}

variable "github_repo_id" {
  description = "GitHub repository numeric ID"
  type        = string
}