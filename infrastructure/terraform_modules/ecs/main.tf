resource "aws_ecs_cluster" "cluster" {
  name = var.app_name
  tags = {
    Name        = "${var.app_name}-ecs"
    Environment = var.environment
  }
}

# To track container logs in Cloudwatch
resource "aws_cloudwatch_log_group" "group" {
  name = "${var.app_name}-${var.environment}-logs"

  tags = {
    Application = var.app_name
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "${var.app_name}-task"
  container_definitions = jsonencode([
    {
      name      = "${var.app_name}-${var.environment}-container"
      image     = "${var.image}"
      cpu       = 10
      memory    = 512
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = "${aws_cloudwatch_log_group.group.id}"
          awslogs-region = "${var.region}"
          "awslogs-stream-prefix": "${var.app_name}-${var.environment}"
        }
      },
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn

  tags = {
    Name        = "${var.app_name}-ecs-td"
    Environment = var.environment
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.app_name}-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Name        = "${var.app_name}-iam-role"
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecsDDBFullAccess_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_alb" "application_load_balancer" {
  name               = "${var.app_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.load_balancer_security_group.id]

  tags = {
    Name        = "${var.app_name}-alb"
    Environment = var.environment
  }
}

resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = var.vpc

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "${var.app_name}-sg"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.app_name}-${var.environment}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/v1/healthcheck"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.app_name}-lb-tg"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  # default_action {
  #   type             = "forward"
  #   target_group_arn = aws_lb_target_group.target_group.id
  # }

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
}

resource "aws_lb_listener" "listener-https" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.id
    type             = "forward"
  }
}