provider "aws" {
    region  = "eu-north-1"
    access_key = "AKIAJZGYAST5JFFYH5OQ"
    secret_key = "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"
}

resource "aws_lambda_function" "hs_lambda" {
  filename      = "hs-lambda.zip"
  function_name = "hs-lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "exports.test"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("hs-lambda.zip")

  runtime = "custom"

  environment {
    variables = {
      foo = "bar"
    }
  }
}