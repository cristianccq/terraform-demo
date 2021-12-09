# -------------   Scalling  CORE task  --------------------------
resource "aws_appautoscaling_target" "target-core" {
  max_capacity              = 3
  min_capacity              = 1
  resource_id               = "service/${aws_ecs_cluster.ecs-cluster.name}/${local.my_name}-core-service"
  scalable_dimension        = "ecs:service:DesiredCount"
  service_namespace         = "ecs"

  depends_on = [
    aws_ecs_service.ecs-core-service
  ]
}

# politica de utilización de la memoria
resource "aws_appautoscaling_policy" "memory_policy_scalling_core" {
  name                      = "core-scaling"
  policy_type               = "TargetTrackingScaling"
  resource_id               = aws_appautoscaling_target.target-core.resource_id
  scalable_dimension        = aws_appautoscaling_target.target-core.scalable_dimension
  service_namespace         = aws_appautoscaling_target.target-core.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
  }
}

# politica de utilización del CPU
resource "aws_appautoscaling_policy" "cpu_policy_scalling_core" {
  name                     = "core-scaling-cpu"
  policy_type              = "TargetTrackingScaling"
  resource_id              = aws_appautoscaling_target.target-core.resource_id
  scalable_dimension       = aws_appautoscaling_target.target-core.scalable_dimension
  service_namespace        = aws_appautoscaling_target.target-core.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}

# -------------   Scalling  ACTIONS task  --------------------------
resource "aws_appautoscaling_target" "target-actions" {
  max_capacity              = 3
  min_capacity              = 1
  resource_id               = "service/${aws_ecs_cluster.ecs-cluster.name}/${local.my_name}-actions-service"
  scalable_dimension        = "ecs:service:DesiredCount"
  service_namespace         = "ecs"

  depends_on = [
    aws_ecs_service.ecs-actions-service
  ]
}

# politica de utilización de la memoria
resource "aws_appautoscaling_policy" "memory_policy_scalling_actions" {
  name                      = "actions-scaling"
  policy_type               = "TargetTrackingScaling"
  resource_id               = aws_appautoscaling_target.target-actions.resource_id
  scalable_dimension        = aws_appautoscaling_target.target-actions.scalable_dimension
  service_namespace         = aws_appautoscaling_target.target-actions.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value             = 80
  }
}

# politica de utilización del CPU
resource "aws_appautoscaling_policy" "cpu_policy_scalling_actions" {
  name                      = "actions-scaling-cpu"
  policy_type               = "TargetTrackingScaling"
  resource_id               = aws_appautoscaling_target.target-actions.resource_id
  scalable_dimension        = aws_appautoscaling_target.target-actions.scalable_dimension
  service_namespace         = aws_appautoscaling_target.target-actions.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}

# -------------   Scalling  Duckling  task  --------------------------
resource "aws_appautoscaling_target" "target-duckling" {
  max_capacity              = 3
  min_capacity              = 1
  resource_id               = "service/${aws_ecs_cluster.ecs-cluster.name}/${local.my_name}-duckling-service"
  scalable_dimension        = "ecs:service:DesiredCount"
  service_namespace         = "ecs"

  depends_on = [
    aws_ecs_service.ecs-duckling-service
  ]
}

# politica de utilización de la memoria
resource "aws_appautoscaling_policy" "memory_policy_scalling_duckling" {
  name                      = "duckling-scaling"
  policy_type               = "TargetTrackingScaling"
  resource_id               = aws_appautoscaling_target.target-duckling.resource_id
  scalable_dimension        = aws_appautoscaling_target.target-duckling.scalable_dimension
  service_namespace         = aws_appautoscaling_target.target-duckling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
  }
}

# politica de utilización del CPU
resource "aws_appautoscaling_policy" "cpu_policy_scalling_duckling" {
  name                      = "duckling-scaling-cpu"
  policy_type               = "TargetTrackingScaling"
  resource_id               = aws_appautoscaling_target.target-duckling.resource_id
  scalable_dimension        = aws_appautoscaling_target.target-duckling.scalable_dimension
  service_namespace         = aws_appautoscaling_target.target-duckling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}