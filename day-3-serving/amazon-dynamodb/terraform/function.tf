module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "insert-data-dynamodb"
  description   = "Function that add values to Dynamodb table"
  handler       = "insert-data-dynamodb.handler"
  runtime       = "python3.9"
  timeout       = 900
  memory_size   = 512
  source_path = "../functions/insert-data-dynamodb"

  layers = [
    data.aws_lambda_layer_version.awswrangler_layer.id
  ]

  environment_variables = {
    access_key   = var.aws_access_key_id
    secret_key   = var.aws_secret_access_key
    REGION_NAME  = var.region
  }
}

data "aws_lambda_layer_version" "awswrangler_layer" {
  layer_name = "arn:aws:lambda:us-east-2:336392948345:layer:AWSDataWrangler-Python39"
  version = 5
}