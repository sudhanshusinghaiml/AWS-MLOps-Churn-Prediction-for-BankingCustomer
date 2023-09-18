## This is needed only in case of ECS-Blue Green Deployment.
## Keeping it for reference, but commenting out so that it is not picked up in the  terraform build

# resource "aws_codedeploy_app" "banking-customer-churn-app" {
#   compute_platform = "ECS"
#   name             = "banking-customer-churn-app"
#   tags             = local.tags
#   depends_on       = [aws_ecs_service.banking_customer_churn_service]
# }
#
# # aws_codedeploy_deployment_group.banking-customer-churn-app-deploy:
# resource "aws_codedeploy_deployment_group" "banking-customer-churn-app-deploy" {
#   app_name = aws_codedeploy_app.banking-customer-churn-app.name
#   # compute_platform       = "ECS"
#   deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
#   deployment_group_name  = "banking-customer-churn-app-deploy"
#   service_role_arn       = local.code_deploy_service_role
#   tags                   = local.tags
#
#   blue_green_deployment_config {
#     deployment_ready_option {
#       action_on_timeout    = "CONTINUE_DEPLOYMENT"
#       wait_time_in_minutes = 0
#     }
#     terminate_blue_instances_on_deployment_success {
#       action                           = "TERMINATE"
#       termination_wait_time_in_minutes = 60
#     }
#   }
#
#   deployment_style {
#     deployment_option = "WITH_TRAFFIC_CONTROL"
#     deployment_type   = "BLUE_GREEN"
#   }
#
#   ecs_service {
#     cluster_name = aws_ecs_cluster.banking_customer_churn_cluster.name
#     service_name = aws_ecs_service.banking_customer_churn_service.name
#   }
#
#   load_balancer_info {
#     target_group_pair_info {
#       prod_traffic_route {
#         listener_arns = [
#           aws_lb_listener.banking_customer_churn_lb_listener1.arn,
#           aws_lb_listener.banking_customer_churn_lb_listener2.arn
#         ]
#       }
#       target_group {
#         name = aws_lb_target_group.banking_customer_churn_tg.name
#       }
#       target_group {
#         name = aws_lb_target_group.banking_customer_churn_tg2.name
#       }
#     }
#   }
#   depends_on = [aws_lb.banking_customer_churn_alb, aws_codedeploy_app.banking-customer-churn-app]
# }