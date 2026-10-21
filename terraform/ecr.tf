resource "aws_ecr_repository" "project_app" {
  name = "${var.project_name}-project-app"

  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  force_delete = false

  tags = {
    Name = "${var.project_name}-project-app"
  }
}