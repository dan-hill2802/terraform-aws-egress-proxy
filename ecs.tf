resource "aws_ecs_cluster" "egress_proxy" {
  count = var.create_ecs_cluster ? 1 : 0

  name = var.project_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

data "aws_ecs_cluster" "egress_proxy" {
  count        = !var.create_ecs_cluster ? 1 : 0
  cluster_name = "egress_proxy"
  id           = var.ecs_cluster_id
}

locals {
  ecs_cluster = var.create_ecs_cluster ? {
    id = aws_ecs_cluster.egress_proxy[0].id
    } : {
    id = data.aws_ecs_cluster.egress_proxy[0].id
  }
}
