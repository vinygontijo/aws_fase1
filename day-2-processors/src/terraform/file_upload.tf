resource "aws_s3_object" "jars" {
  bucket = "owshq-scripts-dev-777696598735"
  key    = "jars/delta-core_2.12-1.0.0.jar"
  source = "../jars/delta-core_2.12-1.0.0.jar"
  etag   = filemd5("../jars/delta-core_2.12-1.0.0.jar")
}

resource "aws_s3_object" "class" {
  bucket = "owshq-scripts-dev-777696598735"
  key    = "job/DeltaProcessing.py"
  source = "../job/DeltaProcessing.py"
  etag   = filemd5("../job/DeltaProcessing.py")
}

resource "aws_s3_object" "etl" {
  bucket = "owshq-scripts-dev-777696598735"
  key    = "job/etl.py"
  source = "../job/etl.py"
  etag   = filemd5("../job/etl.py")
}

resource "aws_s3_object" "variables" {
  bucket = "owshq-scripts-dev-777696598735"
  key    = "job/variables.py"
  source = "../job/variables.py"
  etag   = filemd5("../job/variables.py")
}


