module "redshift" {
  source = "terraform-aws-modules/redshift/aws"

  cluster_identifier    = "owshq-redshift"
  allow_version_upgrade = true
  node_type             = "dc2.large"
  number_of_nodes       = 1

  database_name          = "owshq_redshift"
  master_username        = "owshq_user"
  create_random_password = false
  master_password        = "MySecretPassw0rd1!" # Do better!

  enhanced_vpc_routing   = true
  #vpc_security_group_ids = ["sg-12345678"]
  subnet_ids             = ["subnet-0a4cac5ec5e44f455"]

  # Parameter group
  parameter_group_name        = "custom-parameter-group"
  parameter_group_description = "Custom parameter group"
  parameter_group_parameters = {
    wlm_json_configuration = {
      name = "wlm_json_configuration"
      value = jsonencode([
        {
          query_concurrency = 15
        }
      ])
    }
    require_ssl = {
      name  = "require_ssl"
      value = true
    }
    use_fips_ssl = {
      name  = "use_fips_ssl"
      value = false
    }
    enable_user_activity_logging = {
      name  = "enable_user_activity_logging"
      value = true
    }
    max_concurrency_scaling_clusters = {
      name  = "max_concurrency_scaling_clusters"
      value = 3
    }
    enable_case_sensitive_identifier = {
      name  = "enable_case_sensitive_identifier"
      value = true
    }
  }
  parameter_group_tags = {
    Additional = "CustomParameterGroup"
  }

  # Subnet group
  subnet_group_name        = "example-custom"
  subnet_group_description = "Custom subnet group for example cluster"
  subnet_group_tags = {
    Additional = "CustomSubnetGroup"
  }

  # Scheduled actions
  create_scheduled_action_iam_role = true
  scheduled_actions = {
    pause = {
      name          = "pause-cluster"
      description   = "Pause cluster every night"
      schedule      = "cron(0 22 * * ? *)"
      pause_cluster = true
    }
    resume = {
      name           = "resume-cluster"
      description    = "Resume cluster every morning"
      schedule       = "cron(0 12 * * ? *)"
      resume_cluster = true
    }
  }

  # Endpoint access
  create_endpoint_access          = true
  endpoint_name                   = "example-example"
  endpoint_subnet_group_name      = "example-subnet-group"
  endpoint_vpc_security_group_ids = ["sg-12345678"]

  # Usage limits
  usage_limits = {
    currency_scaling = {
      feature_type  = "concurrency-scaling"
      limit_type    = "time"
      amount        = 60
      breach_action = "emit-metric"
    }
    spectrum = {
      feature_type  = "spectrum"
      limit_type    = "data-scanned"
      amount        = 2
      breach_action = "disable"
      tags = {
        Additional = "CustomUsageLimits"
      }
    }
  }
}