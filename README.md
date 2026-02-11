# Terramate Catalyst Examples

This repository contains practical examples demonstrating how [Terramate Catalyst](https://github.com/terramate-io/terramate-catalyst) enables developers to self-service provision infrastructure on AWS using Terraform—without writing Terraform code themselves.

## About Terramate Catalyst

[Terramate Catalyst](https://terramate.io/rethinking-iac/technical-introduction-to-terramate-catalyst/) transforms how infrastructure is delivered and consumed inside organizations by introducing two new primitives: **Bundles** and **Components**.

### Components

Components are reusable, opinionated infrastructure blueprints defined by platform engineers. They encode organizational standards, governance rules, naming conventions, security policies, cost controls, and more. In practice, a Component may represent a "database setup," "message queue," "VPC," "cache cluster," or any other infrastructure pattern.

Components can contain any arbitrary IaC—Terraform/OpenTofu resources, Terraform modules, Kubernetes manifests, or any other infrastructure-as-code. The idea is to provide infrastructure patterns that can be reused by platform engineers and sourced by one or multiple Bundles.

### Bundles

Bundles assemble one or more Components into ready-to-use, deployable units. These are what developers and AI agents consume when requesting infrastructure. Bundles abstract away all the complexity: no need to write Terraform, manage state, or deal with providers—you declare what you need (e.g., "a database for service X in environment Y"), and Catalyst fills in the rest.

### Division of Responsibilities

This separation creates a **clear division of responsibility**:

- **Platform Engineers** design and maintain infrastructure logic, compliance, scalability, and IaC best practices.
- **Developers** (or AI agents) request infrastructure via simple, high-level abstractions—without needing to understand Terraform, module variables, or backend configuration.

In other words: Catalyst doesn't replace IaC—it operationalizes it and elegantly hides the complexity for non-expert infrastructure "consumers".

## Installation

**Terramate Catalyst** is distributed separately from the Terramate CLI as a standalone binary on GitHub. It ships with two executables—`terramate` and `terramate-ls`—which act as drop-in replacements for the standard Terramate CLI.

### Install Catalyst

The easiest way to install Catalyst is via the **asdf** package manager:

```sh
asdf plugin add terramate-catalyst https://github.com/terramate-io/asdf-terramate-catalyst
asdf set -u terramate-catalyst 0.16.0-beta12
```

Alternatively, you can download the binaries directly from the [GitHub releases](https://github.com/terramate-io/terramate-catalyst/releases). More installation options—including additional package managers—are coming soon.

### Verify Installation

After installing Terramate Catalyst, verify the installation:

```sh
terramate version
# Should output: 0.16.0-beta12
```

> **Note:** If you are already using Terramate CLI, Terramate Catalyst acts as a drop-in replacement. It provides two binaries (`terramate` and `terramate-ls`) that replace your standard Terramate CLI installation.

## Getting Started

Clone this repository to explore the examples:

```sh
git clone git@github.com:terramate-io/terramate-catalyst-examples.git
cd terramate-catalyst-examples
```

### Explore Available Bundles

To see what infrastructure bundles are available in this repository, run:

```sh
terramate scaffold
```

This interactive command will show you all available bundles and guide you through creating infrastructure instances.

![Bundles Overview](assets/img/bundles-overview.png)

### Example: Create an S3 Bucket

Choose the **S3 Bucket Bundle** to create an S3 bucket with just a few prompts—no Terraform knowledge required:

![S3 Creation](assets/img/s3-creation.png)

The scaffold command will:
1. Prompt you for essential inputs (bucket name, ACL, tags)
2. Create a bundle instance file (`.tm.yml`)
3. Generate all necessary Terramate stacks and Terraform configuration

After scaffolding, generate the infrastructure code:

```sh
terramate generate
```

Then deploy with Terraform:

```sh
terramate run -- terraform init
terramate run -- terraform plan
terramate run -- terraform apply
```

## Examples in This Repository

This repository demonstrates several real-world scenarios:

### 1. Simple S3 Bucket Deployment

**Bundle:** `example.com/tf-aws-s3/v1`

Allows developers to deploy a simple S3 bucket by defining its name and ACL only—without ever touching Terraform.

**Component:** `example.com/terramate-aws-s3-bucket/v1`

Creates an S3 bucket with:
- Configurable ACL (default: private)
- Versioning enabled
- Server-side encryption (AES256)

### 2. Complete ECS Fargate Cluster

**Bundle:** `example.com/tf-aws-complete-ecs-fargate-cluster/v1`

Deploys a complete, production-ready ECS Fargate cluster with VPC, ALB, and networking—all in minutes.

**Components:**
- `example.com/terramate-aws-vpc/v1` - VPC with public/private subnets, NAT Gateway
- `example.com/terramate-aws-alb/v1` - Application Load Balancer
- `example.com/terramate-aws-ecs-cluster/v1` - ECS Fargate cluster

This bundle demonstrates how multiple components work together to create complex infrastructure.

### 3. ECS Fargate Service Deployment

**Bundle:** `example.com/tf-aws-ecs-fargate-service/v1`

Deploys containerized services on existing ECS clusters. The bundle automatically discovers available clusters and configures the ALB to route traffic to the new service.

**Component:** `example.com/terramate-aws-ecs-service/v1`

Creates an ECS Fargate service with:
- Container definitions
- Load balancer integration
- Automatic ALB listener rule creation
- Blue/green deployment support

This example showcases **Bundle-to-Bundle relationships**—how bundles can discover and integrate with infrastructure created by other bundles.

## Available Bundles

### AWS S3 Bucket (`example.com/tf-aws-s3/v1`)

Creates and manages an S3 bucket on AWS. The bucket can be configured as private or public, with private as the default.

**Features:**
- Configurable ACL/visibility (private/public)
- Versioning enabled
- Server-side encryption (AES256)
- Configurable tags

### Complete ECS Fargate Cluster (`example.com/tf-aws-complete-ecs-fargate-cluster/v1`)

Creates a complete, production-ready ECS Fargate cluster infrastructure on AWS.

**Features:**
- VPC with public and private subnets
- NAT Gateway and Internet Gateway
- Application Load Balancer (ALB) in public subnets
- ECS Fargate cluster with capacity provider strategy
- Automatic detection and integration of ECS services

### ECS Fargate Service (`example.com/tf-aws-ecs-fargate-service/v1`)

Creates and manages an ECS Fargate service that can be attached to existing ECS clusters, VPCs, and Application Load Balancers.

**Features:**
- Discovers existing ECS clusters via bundle queries
- Uses AWS data sources to discover resources by tags
- Configures container definitions and load balancer integration
- Automatically updates ALB with listener rules and target groups
- Supports blue/green deployment configuration

## Available Components

### AWS VPC (`example.com/terramate-aws-vpc/v1`)

Creates a VPC on AWS with public and private subnets, NAT gateway, and internet gateway.

**Features:**
- VPC with configurable CIDR block
- Public and private subnets across multiple availability zones
- NAT Gateway and Internet Gateway
- Route tables and security groups

### AWS Application Load Balancer (`example.com/terramate-aws-alb/v1`)

Creates an Application Load Balancer on AWS with automatic detection of ECS services.

**Features:**
- Application Load Balancer in public subnets
- Configurable listeners and target groups
- Automatic listener rule creation for ECS services
- Security groups for ALB

### AWS ECS Cluster (`example.com/terramate-aws-ecs-cluster/v1`)

Creates an ECS cluster on AWS with a default capacity provider strategy.

**Features:**
- ECS Fargate cluster
- Capacity provider strategy (Fargate Spot + on-demand)
- Configurable cluster settings

### AWS ECS Service (`example.com/terramate-aws-ecs-service/v1`)

Creates an ECS Fargate service on AWS with container definitions, load balancer integration, and blue/green deployment support.

**Features:**
- ECS Fargate service
- Container definitions with configurable images, ports, CPU, and memory
- Load balancer integration
- Uses AWS data sources to reference existing clusters, VPCs, and ALBs
- Uses private subnets with NAT Gateway for internet access
- Supports blue/green deployment configuration

### AWS S3 Bucket (`example.com/terramate-aws-s3-bucket/v1`)

Creates an S3 bucket on AWS with configurable ACL, versioning, and encryption.

**Features:**
- Configurable ACL/visibility (private/public)
- Versioning enabled
- Server-side encryption (AES256)
- Configurable tags

## How It Works

### Scaffolding Complex IaC

Catalyst works by scaffolding the entire IaC stack, including state configuration and providers, but it doesn't require developers to know Terraform, OpenTofu, or their configuration language (HCL).

Developers can use:
- The `terramate scaffold` command to choose from bundles available in the current repository, a remote repository, or the upcoming registry in Terramate Cloud
- The Terramate MCP Server for AI agent integration
- Direct bundle instance file creation

### Bundle Relationships

Bundles can discover and integrate with infrastructure created by other bundles. For example, the ECS Fargate Service bundle can query for existing ECS clusters:

```hcl
input "cluster_slug" {
  type        = string
  description = "Bundle UUID of the ECS cluster to attach this service to"

  allowed_values = [
    for cluster in tm_bundles("example.com/tf-aws-complete-ecs-fargate-cluster/v1") :
    { name = "${cluster.input.name.value} (${cluster.export.alias.value} / ${cluster.uuid})", value = cluster.export.alias.value }
  ]
  prompt                = "Elastic Container Service (ECS) Cluster"
}
```

When a new ECS service is deployed, the ALB bundle automatically detects it and updates the load balancer configuration to include the necessary listener rules and target groups.

### Versioning

Both Components and Bundles can be managed and versioned in Git repositories using semantic versioning. The upcoming Terramate Registry will provide a dashboard to track Bundle and Component usage, as well as versions across multiple repositories and teams.

## Project Structure

```bash
terramate-catalyst-examples/
│
├── bundles/              # Bundle definitions
│   └── example.com/      # use your domain here for your own bundles
│       ├── tf-aws-complete-ecs-fargate-cluster/   # The Fargate Cluster  bundle
│       ├── tf-aws-ecs-fargate-service/            # The Fargate Workload bundle
│       ├── tf-aws-s3/                             # The S3 bundle
│       └── tf-aws-s3/v1/components/terramate-aws-s3-bucket/  # nested component definitions
│
├── components/          # Component definitions
│   └── example.com/     # use your domain here for your own bundles
│       ├── terramate-aws-vpc/v1/
│       ├── terramate-aws-alb/v1/
│       ├── terramate-aws-ecs-cluster/v1/
│       └── terramate-aws-ecs-service/v1/
│
│ # Bundle instances (configured by scaffold and reconfigure commands or manually maintained)
│ #  - each instance contains configurations for all environments in a single file
│
├── configs/fargate-clusters/{slug}/cluster.tm.yml         # Bundle instance files of clusters
├── configs/fargate-clusters/{slug}/service_{name}.tm.yml  # Bundle instance files for workloads
├── configs/s3-buckets/s3_{name}.tm.yml                    # Bundle instance files for s3-buckets
│
│ # Generated Terramate Stacks and Terraform Code for all configured environments
│
│   # stacks managed by fargate cluster bundles
├── stacks/{env}/fargate-clusters/{cluster}/vpc                  # a clusters VPC stack
├── stacks/{env}/fargate-clusters/{cluster}/alb                  # a clusters ALB stack
├── stacks/{env}/fargate-clusters/{cluster}/cluster              # the cluster itself stack
│
│   # stacks managed by fargate workload bundles
├── stacks/{env}/fargate-clusters/{cluster}/workloads/{service}  # workloads for the cluster
│
│   # stacks managed by S3 bundles
├── stacks/{env}/s3-buckets/{name}  # S3 buckets
│
└── imports/             # Shared configuration and mixins
```

## Learn More

- **[Technical Introduction to Terramate Catalyst](https://terramate.io/rethinking-iac/technical-introduction-to-terramate-catalyst/)** - Comprehensive guide with hands-on examples
- **[Terramate Catalyst GitHub Repository](https://github.com/terramate-io/terramate-catalyst)**
- **[Terramate Documentation](https://terramate.io/docs/)** - Terramate CLI documentation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
