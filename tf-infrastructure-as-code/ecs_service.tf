resource "aws_ecs_service" "banking_customer_churn_service" {
  name                               = "banking_customer_churn_service"
  cluster                            = aws_ecs_cluster.banking_customer_churn_cluster.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  enable_ecs_managed_tags            = true
  enable_execute_command             = false
  health_check_grace_period_seconds  = 0
  desired_count                      = 2
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  scheduling_strategy                = "REPLICA"
  tags                               = local.tags
  tags_all                           = local.tags

  task_definition = format("%s:%s", aws_ecs_task_definition.customer_churn_task_definition.family, aws_ecs_task_definition.customer_churn_task_definition.revision)

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = "customer_churn_container"
    container_port   = 5000
    target_group_arn = aws_lb_target_group.banking_customer_churn_tg.arn
  }

  network_configuration {
    security_groups  = local.security_groups
    assign_public_ip = true
    subnets          = local.subnets
  }

  depends_on = [aws_ecs_task_definition.customer_churn_task_definition]
}