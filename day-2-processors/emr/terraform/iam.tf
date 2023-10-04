resource "aws_iam_role" "lambda_s3" {
  name               = "${local.prefix}_Role_lambda_EMR_S3"
  path               = "/"
  description        = "Provides write permissions to CloudWatch Logs and S3 Full Access"
  assume_role_policy = file("./permissions/Role_Lambda_S3.json")
}

resource "aws_iam_policy" "lambda_s3" {
  name        = "${local.prefix}_Policy_lambda_EMR_S3"
  path        = "/"
  description = "Provides write permissions to CloudWatch Logs and S3 Full Access"
  policy      = file("./permissions/Policy_Lambda_S3.json")
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_s3.name
  policy_arn = aws_iam_policy.lambda_s3.arn
}

resource "aws_iam_role" "EmrDefaultRole" {
  name               = "EmrDefaultRole"
  path               = "/"
  description        = "Default role for EMR"
  assume_role_policy = file("./permissions/EmrDefaultRole.json")
}

resource "aws_iam_policy" "iam_emr_service_policy" {
  name        = "iam_emr_service_policy"
  path        = "/"
  description = "Policies for EMR Default Role"
  policy      = file("./permissions/iam_emr_service_policy.json")
}

resource "aws_iam_role_policy_attachment" "emr_role_attach" {
  role       = aws_iam_role.EmrDefaultRole.name
  policy_arn = aws_iam_policy.iam_emr_service_policy.arn
}

resource "aws_iam_role" "EmrEc2DefaultRole" {
  name               = "EmrEc2DefaultRole"
  path               = "/"
  description        = "Default role for EMR EC2"
  assume_role_policy = file("./permissions/EmrEc2DefaultRole.json")
}

resource "aws_iam_policy" "emr_profile" {
  name        = "emr_profile"
  path        = "/"
  description = "Policies for EMR EC2 Default Role"
  policy      = file("./permissions/emr_profile.json")
}

resource "aws_iam_role_policy_attachment" "emr_ec2_role_attach" {
  role       = aws_iam_role.EmrEc2DefaultRole.name
  policy_arn = aws_iam_policy.emr_profile.arn
}

resource "aws_iam_instance_profile" "emr_profile" {
  name = "EmrEc2DefaultRole_profile"
  role = aws_iam_role.EmrEc2DefaultRole.name
} 