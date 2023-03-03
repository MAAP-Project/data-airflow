resource "aws_ecs_task_definition" "veda_task_definition" {


  container_definitions = jsonencode([

    {
      name      = "${var.prefix}-veda-stac-build"
      image     = "${local.account_id}.dkr.ecr.${local.aws_region}.amazonaws.com/${var.prefix}-veda-build_stac"
      essential = true,
      logConfiguration = {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": module.mwaa.log_group_name,
            "awslogs-region": local.aws_region,
            "awslogs-stream-prefix": "ecs"
          }
      }
    }
  ])
  family                   = "${var.prefix}-tasks"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn = module.mwaa.mwaa_role_arn
  task_role_arn = module.mwaa.mwaa_role_arn
}