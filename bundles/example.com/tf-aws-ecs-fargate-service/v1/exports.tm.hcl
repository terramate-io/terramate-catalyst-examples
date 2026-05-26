define bundle {

  export "cluster_slug" {
    value = bundle.let.cluster.alias
  }

  export "listener_rule" {
    value = {
      priority = 5000
      actions = [{
        forward = {
          target_group_key = bundle.let.service_name
        }
      }]


      conditions = [{
        path_pattern = {
          values = [bundle.input.path_pattern.value]
        }
      }]
    }
  }

  export "target_group" {
    value = {
      name        = tm_substr(bundle.let.service_name, 0, 32)
      port        = bundle.input.container_port.value
      protocol    = "HTTP"
      target_type = "ip"

      create_attachment = false

      deregistration_delay = 30

      health_check = {
        enabled             = true
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
        interval            = 30
        path                = tm_replace(bundle.input.path_pattern.value, "*", "")
        matcher             = "200"
        protocol            = "HTTP"
        port                = "traffic-port"
      }
    }
  }
}
