data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

module "dms" {
  source  = "terraform-aws-modules/dms/aws"
  version = "~> 1.0"

  # Subnet group
  repl_subnet_group_name        = aws_db_subnet_group.education.name
  repl_subnet_group_description = aws_db_subnet_group.education.description
  repl_subnet_group_subnet_ids  = [module.vpc.database_subnets[0], module.vpc.database_subnets[1], module.vpc.database_subnets[2]]

  # Instance
  repl_instance_apply_immediately      = true
  repl_instance_multi_az               = false
  repl_instance_class                  = "dms.t3.large"
  repl_instance_id                     = "owshqReplInstance"
  repl_instance_publicly_accessible    = true
  repl_instance_vpc_security_group_ids = [aws_security_group.allow_mysql.id]

  endpoints = {
    source = {
      database_name               = aws_db_instance.default.db_name
      endpoint_id                 = "owshqmysql-source"
      endpoint_type               = "source"
      engine_name                 = aws_db_instance.default.engine
      extra_connection_attributes = "heartbeatFrequency=1;"
      username                    = aws_db_instance.default.username
      password                    = aws_db_instance.default.password
      port                        = 3306
      server_name                 = aws_db_instance.default.address
      ssl_mode                    = "none"
      tags                        = { EndpointType = "source" }
    }

    destination = {
      endpoint_id                 = "owshqs3-target"
      endpoint_type               = "target"
      engine_name                 = "s3"
      extra_connection_attributes = "DataFormat=parquet;parquetVersion=PARQUET_2_0;"
      s3_settings = {
        bucket_folder           = "mysql"
        bucket_name             = aws_s3_bucket_public_access_block.public_access_block[0].bucket
        compression_type        = "GZIP"
        service_access_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/dms-s3-role"
        data_format             = "parquet"
      }
    }
  }

  replication_tasks = {
    s3_import = {
      replication_task_id = "mysqlToS3"
      migration_type      = "full-load"
      table_mappings      = file("configs/table_mappings.json")
      source_endpoint_key = "source"
      target_endpoint_key = "destination"
      tags                = { Task = "mysql-to-s3" }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


