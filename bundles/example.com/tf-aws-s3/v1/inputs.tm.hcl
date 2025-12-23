define bundle {
  input "env" {
    type        = string
    description = <<-EOF
		  The environment to create the S3 bucket in.
		EOF

    # Scaffolding configuration
    prompt = "Environment"
    allowed_values = [
      for k, v in global.environments : { name = v, value = k }
    ]
    required_for_scaffold = true
    multiselect           = false
  }

  input "name" {
    type        = string
    description = "A globaly unique name of the S3 bucket"

    # Scaffolding configuration
    prompt                = "S3 Bucket Name"
    required_for_scaffold = true
  }

  input "visibility" {
    type        = string
    prompt      = "Bucket Visibility"
    description = "Whether the bucket should be private or public"
    default     = "private"
    allowed_values = [
      { name = "Private", value = "private" },
      { name = "Public Read", value = "public-read" },
      { name = "Public Read/Write", value = "public-read-write" }
    ]
  }
}
