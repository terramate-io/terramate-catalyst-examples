define bundle {

  export "cluster_slug" {
    value = bundle.input.cluster_slug.value
  }

  export "listener_rule" {
    value = {
      priority = 5000
      actions = [{
        forward = {
          target_group_key = tm_join("-", [bundle.input.cluster_slug.value, tm_slug(bundle.input.service_name.value)])
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
      name        = tm_substr(tm_join("-", [bundle.input.cluster_slug.value, tm_slug(bundle.input.service_name.value)]), 0, 32)
      port        = bundle.input.container_port.value
      protocol    = "HTTP"
      target_type = "ip"

      # ECS manages target attachments, so don't create them here
      create_attachment = false

      deregistration_delay = 30

      # tags = tm_merge(
      #   {
      #     # "Name"                                     = "${tm_slug(bundle.input.service_name.value)}-${resource.value.inputs.target_group_key.value}" # TODO why group key?
      #     "Name"                           = tm_slug(bundle.input.service_name.value)
      #     "{bundle.class}/for-bundle-uuid" = "bundle.uuid"
      #     # "${bundle.class}/bundle-alias" = bundle.alias
      #     "{bundle.class}/for-bundle-alias" = tm_join("-", [bundle.input.cluster_slug.value, tm_slug(bundle.input.service_name.value)])
      #   },
      #   # bundle.input.tags.value,  # TODO
      # )
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
        interval            = 30
        # Remove wildcard and ensure path starts with /
        # Split by /, prepend empty string to force leading /, then join
        path     = tm_join("/", tm_concat([""], tm_split("/", tm_replace(bundle.input.path_pattern.value, "*", ""))))
        matcher  = "200"
        protocol = "HTTP"
        port     = "traffic-port"
      }
    }
  }
}
