define bundle metadata {
  class   = "example.com/tf-aws-vpc-alb/v1"
  version = "1.0.0"

  name        = "VPC and ALB"
  description = <<-EOF
    This Bundle creates and manages a VPC with public and private subnets, NAT gateway,
    and an Application Load Balancer infrastructure. The ALB is configured with a basic
    HTTP listener, but target groups and routing rules should be added when deploying services.
  EOF
}

define bundle {
  alias = tm_slug(bundle.input.name.value)

  scaffolding {
    path = "/stacks/${bundle.input.env.value}/vpc-alb/_bundle_vpc_alb_${tm_slug(bundle.input.name.value)}.tm.hcl"
    name = tm_slug(bundle.input.name.value)
  }
}
