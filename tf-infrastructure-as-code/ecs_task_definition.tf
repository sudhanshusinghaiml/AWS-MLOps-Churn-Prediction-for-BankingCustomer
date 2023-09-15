resource "aws_ecs_task_definition" "customer_churn_task_definition" {
  container_definitions = jsonencode(
    [
      {
        image     = format("%s%s", aws_ecr_repository.banking_customer_churn_ecr_repo.repository_url, ":latest")
        cpu       = 0
        essential = true
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group = "/ecs/"
            awslogs-region = "us-east-1"
            awslogs-create-group: "true"
            awslogs-stream-prefix = "ecs"
          }
        }
        memoryReservation = 128
        name = "customer_churn_container"

        portMappings = [
          {
            containerPort = 5000
            hostPort      = 5000
            protocol      = "tcp"
          }
        ]
      }
    ]
  )
  cpu = "1024"
  execution_role_arn = local.ecs_task_role
  family = "customer_churn_task_definition"
  memory = "4096"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  tags = local.tags
  task_role_arn = local.ecs_task_role

  depends_on = [aws_ecs_cluster.banking_customer_churn_cluster]
}