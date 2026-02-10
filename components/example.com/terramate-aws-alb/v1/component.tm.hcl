define component metadata {
  class       = "example.com/terramate-aws-alb/v1"
  version     = "1.0.0"
  name        = "AWS Application Load Balancer (AWS ALB)"
  description = <<-EOF
    Creates an Application Load Balancer (ALB) on AWS.
  EOF
}

# define component {
#   environments {
#     required  = false # this component requires at least one envrionment to be used Default: `false`
#     # supported = true # can not be `false` if `required` is `true`. Not PoC
#   }
# }
