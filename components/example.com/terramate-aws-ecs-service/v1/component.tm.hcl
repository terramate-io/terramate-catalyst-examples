define component metadata {
  class       = "example.com/aws-ecs-service/v1"
  version     = "1.0.0"
  name        = "AWS ECS Service"
  description = <<-EOF
    Component that allows creating an ECS Fargate service on AWS with container definitions, load balancer integration, and blue/green deployment support.

    Uses AWS data sources to reference existing clusters, VPCs, and ALBs.
  EOF
}
