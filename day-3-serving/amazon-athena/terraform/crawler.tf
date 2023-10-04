resource "aws_glue_crawler" "crawler" {
  database_name = "owshq-database"
  name          = "owshq-crawler"
  role          = aws_iam_role.glue_job.arn

  delta_target {
    connection_name = aws_glue_connection.delta_connection.name
    delta_tables = [
      "s3://owshq-gold-layer-dev-777696598735/delivery/customers/",
      "s3://owshq-gold-layer-dev-777696598735/delivery/customer_flights/"
    ]
    write_manifest = "true"
  }
}

resource "aws_glue_connection" "delta_connection" {
  name = "delta_connection"
  connection_type = "NETWORK"

    physical_connection_requirements {
      availability_zone      = "us-east-2a"
      security_group_id_list = ["sg-067ca27b4a4413223"]
      subnet_id              = "subnet-0bc0c5d43ddd36523"
    }
}