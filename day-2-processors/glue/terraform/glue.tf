resource "aws_glue_job" "glue_job" {
  name              = "glue_script"
  role_arn          = aws_iam_role.glue_job.arn
  glue_version      = "3.0"
  worker_type       = "Standard"
  number_of_workers = 2
  timeout           = 5

  command {
    script_location = "s3://${local.glue_bucket}/job/etl.py"
    python_version  = "3"
  }

  default_arguments = {
    "--additional-python-modules"       = "delta-spark==1.0.0"
    "--extra-jars"                      = "s3://${local.glue_bucket}/jars/delta-core_2.12-1.0.0.jar"
    "--conf spark.delta.logStore.class" = "org.apache.spark.sql.delta.storage.S3SingleDriverLogStore"
    "--conf spark.sql.extensions"       = "io.delta.sql.DeltaSparkSessionExtension"
    "--extra-py-files" = "s3://${local.glue_bucket}/job/DeltaProcessing.py, s3://${local.glue_bucket}/job/variables.py"
  }
}