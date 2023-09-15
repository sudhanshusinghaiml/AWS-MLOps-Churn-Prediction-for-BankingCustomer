resource "aws_ecs_cluster" "banking_customer_churn_cluster" {
  name = "banking_customer_churn_cluster"
  tags = local.tags

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  depends_on = [aws_lb_listener.banking_customer_churn_lb_listener1, aws_lb_listener.banking_customer_churn_lb_listener2]
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_provider" {
  cluster_name = aws_ecs_cluster.banking_customer_churn_cluster.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }

  depends_on = [aws_ecs_cluster.banking_customer_churn_cluster]
}