# terramate-catalyst-examples

Examples for the Terramate Catalyst

## Bundles

Bundles are high-level, reusable infrastructure patterns that combine multiple components:

### `tf-aws-vpc-alb`
- Creates a VPC with public and private subnets
- Sets up NAT Gateway and Internet Gateway
- Deploys an Application Load Balancer (ALB) in public subnets
- Provides foundational networking infrastructure

### `tf-aws-ecs-fargate-cluster`
- Creates an ECS Fargate cluster
- Configures capacity provider strategy (Fargate Spot + on-demand)
- Sets up CloudWatch logging

### `tf-aws-ecs-fargate-service`
- Creates an ECS Fargate service attached to existing cluster, VPC, and ALB
- Uses AWS data sources to discover resources by tags
- Configures container definitions, load balancer integration, and auto-scaling

### `tf-aws-s3`
- Creates a private S3 bucket
- Enables versioning
- Configures basic bucket settings

## Components

Components are reusable Terraform modules that create specific AWS resources:

### `terramate-aws-vpc`
- Creates VPC with public and private subnets
- Configures NAT Gateway and Internet Gateway
- Sets up route tables and security groups

### `terramate-aws-alb`
- Creates Application Load Balancer
- Configures listeners and target groups
- Sets up security groups for ALB

### `terramate-aws-ecs-cluster`
- Creates ECS cluster
- Configures capacity providers
- Sets up CloudWatch logging

### `terramate-aws-ecs-service`
- Creates ECS Fargate service
- Configures container definitions
- Sets up load balancer integration
- Configures auto-scaling policies
- Uses private subnets with NAT Gateway for internet access

### `terramate-aws-s3-bucket`
- Creates S3 bucket
- Configures versioning and encryption
- Sets up bucket policies
