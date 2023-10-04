module "lambda_function_in_vpc" {
  source = "terraform-aws-modules/lambda/aws"
  
  function_name = "populate-mysql"
  description   = "Function that creates and populates tables in mysql RDS"
  handler       = "handler.populate_mysql"
  runtime       = "python3.9"
  timeout       = 900

  source_path = "../functions/insert_into_mysql"

  vpc_subnet_ids         = module.vpc.public_subnets
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]
  attach_network_policy  = true

    layers = [
    module.lambda_layer.lambda_layer_arn
  ]

    environment_variables = {
        DB_INSTANCE_ADDRESS            = aws_db_instance.default.address
        DB_USERNAME                    = aws_db_instance.default.username
        DB_PASSWORD                    = aws_db_instance.default.password
        DB_PORT                        = 3306
        DB_NAME                        = aws_db_instance.default.db_name
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