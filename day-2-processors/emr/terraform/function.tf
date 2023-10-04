module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  for_each = toset(["deploy-emr", "terminate-emr", "add-emr-step"])

  function_name = each.key
  description   = "Function that interacts with an EMR Cluster"
  handler       = "${each.key}.handler"
  runtime       = "python3.9"
  timeout       = 900

  source_path = "../functions/${each.key}"

  layers = [
    module.lambda_layer.lambda_layer_arn
  ]

  environment_variables = {
    access_key   = var.aws_access_key_id
    secret_key   = var.aws_secret_access_key
    REGION_NAME  = var.region
    CLUSTER_NAME = var.cluster_name

  }
}

module "lambda_layer" {
  source = "terraform-aws-modules/lambda/aws"

  create_layer = true

  layer_name          = "python-dependencies"
  description         = "Lambda Layer with Python dependencies"
  compatible_runtimes = ["python3.9"]

  source_path = "../lambda_layer/python.zip"
}