resource "aws_kinesis_firehose_delivery_stream" "kinesis_firehose_stream" {
  name        = "owshq-kinesis-firehose-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn       = aws_iam_role.kinesis_firehose_stream_role.arn
    bucket_arn     = "arn:aws:s3:::${aws_s3_bucket_public_access_block.public_access_block[4].bucket}"
    buffer_size    = 128
    s3_backup_mode = "Disabled"
    prefix         = "logs/"

    processing_configuration {
      enabled = true

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.lambda_kinesis_firehose_data_transformation.arn}"
        }
      }
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.kinesis_firehose_stream_logging_group.name
      log_stream_name = aws_cloudwatch_log_stream.kinesis_firehose_stream_logging_stream.name
    }
  }
}

resource "aws_cloudwatch_log_group" "kinesis_firehose_stream_logging_group" {
  name = "/aws/kinesisfirehose/owshq"
}

resource "aws_cloudwatch_log_stream" "kinesis_firehose_stream_logging_stream" {
  log_group_name = aws_cloudwatch_log_group.kinesis_firehose_stream_logging_group.name
  name           = "S3Delivery"
}

data "archive_file" "kinesis_firehose_data_transformation" {
  type        = "zip"
  source_file = "../functions/log_transformation/transform_log.py"
  output_path = "../functions/log_transformation/transform_log.zip"
}

resource "aws_cloudwatch_log_group" "lambda_function_logging_group" {
  name = "/aws/lambda/transform_log"
}

resource "aws_lambda_function" "lambda_kinesis_firehose_data_transformation" {
  filename      = data.archive_file.kinesis_firehose_data_transformation.output_path
  function_name = "transform_log"

  role             = aws_iam_role.lambda.arn
  handler          = "transform_log.lambda_handler"
  source_code_hash = data.archive_file.kinesis_firehose_data_transformation.output_base64sha256
  runtime          = "python3.9"
  timeout          = 900
}

resource "aws_cloudwatch_log_subscription_filter" "cloudwatch_subscription_filter" {
  name           = "logs-filter"
  log_group_name = "/aws/lambda/populate-mysql"
  filter_pattern = "Error"

  destination_arn = aws_kinesis_firehose_delivery_stream.kinesis_firehose_stream.arn
  distribution    = "ByLogStream"

  role_arn = aws_iam_role.cloudwatch_logs_role.arn
}