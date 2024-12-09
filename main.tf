# 1. Configuring the AWS Provider
provider "aws" {
  region = "us-east-1"  # Specifiying the AWS region for our resources.
}
# Why: This tells Terraform to use AWS as the cloud provider and specifies the region where resources will be created. 
# You can replace us-east-1 with another region if needed.


# 2. Create an S3 Bucket for Storage
resource "aws_s3_bucket" "serverless_app_bucket" {
  bucket = "iriusrisk-tech-challenge-bucket-12345"  # The globally unique name of your S3 bucket
}
# Why: An S3 bucket is required to store the JSON file with the top 10 words.
# This bucket will be accessed by the Lambda function.


# 3. Block Public Access for the S3 Bucket (instead of using ACL), 
# As AWS S3 Bucket ACLs (Access Control Lists) are no longer supported for newly created S3 buckets.
resource "aws_s3_bucket_public_access_block" "serverless_app_bucket_access" {
  bucket = aws_s3_bucket.serverless_app_bucket.id  # Reference to the bucket created above
  block_public_acls = true  # Block public ACLs to avoid public access
  block_public_policy = true  # Block public policies
  ignore_public_acls = true  # Ignore public ACLs
  restrict_public_buckets = true  # Restrict public buckets
}
# Why: This ensures the bucket is private and secure from unauthorized access.


# 4. Define the Lambda Function
resource "aws_lambda_function" "process_text" {
  function_name = "process_text_lambda"
  runtime = "python3.9"  # Specify the Python runtime
  handler = "count_top_ten_words.count_top_ten_words"
  filename = "${path.module}/count_top_ten_words.zip"  # Path to your count_top_ten_words.py ZIP file
  role = aws_iam_role.lambda_exec.arn # Attach the IAM role
}
# Why: This creates the Lambda function that processes the POST request and writes data to S3 bucket.
# make sure to compress your lambda_python.py file to count_top_ten_words.zip


# 5. Set Up IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17", # Version = "2012-10-17" is just the date of the AWS policy format we are using. 
    # It’s needed to keep things up-to-date and working with AWS’s current setup
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = { Service = "lambda.amazonaws.com" }
      }
    ]
  })
}
# Why: Lambda execution needs an IAM role for executing actions like writing to S3


# 6. Define an IAM Policy for Lambda-S3 Interaction
resource "aws_iam_policy" "lambda_s3_policy" {
  name = "lambda_s3_policy"
  description = "Policy for Lambda to access S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17", # Version = "2012-10-17" is just the date of the AWS policy format we are using. 
    Statement = [
      {
        Action = ["s3:PutObject", "s3:GetObject"],  # Permissions for S3
        Effect = "Allow",
        Resource = "${aws_s3_bucket.serverless_app_bucket.arn}/*"
      }
    ]
  })
}
# Why: This policy gives Lambda permissions to read and write data in our S3 bucket
# You can find the list of permissions here: https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazons3.html



# 7. Attach the Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "lambda_s3_attach" {
  role = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}
# Why: Attaching this policy allows the Lambda role to interact with the S3 bucket.
# https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html 



# 8. Set Up an API Gateway
resource "aws_apigatewayv2_api" "http_api" {
  name = "serverless_app_api"
  protocol_type = "HTTP" # HTTP APIs are cheaper than REST APIs, making them ideal for serverless applications
}
# Why: API Gateway is used to expose the Lambda function as a POST endpoint for external requests.



# 9. Link API Gateway to Lambda Function
# a) Create the Integration
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = aws_apigatewayv2_api.http_api.id  # Referencing the previously created API
  integration_type = "AWS_PROXY"  # Use AWS_PROXY to pass the event directly to Lambda
  integration_uri  = aws_lambda_function.process_text.arn  # Link to our Lambda function's ARN(Amazon Resource Name)
  payload_format_version = "2.0"  # Use HTTP API payload format
}
# Why: This integration confirms that requests to the API Gateway are sent to the Lambda function.
# b) Defining the Route
resource "aws_apigatewayv2_route" "post_route" {
  api_id = aws_apigatewayv2_api.http_api.id # Reference to the API
  route_key = "POST /process_text"  # Define the POST method at '/process_text'
  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}" # Link to the integration
}
# Why: This creates the POST endpoint /process_text and connects it to the integration with the Lambda function.


# 10. Grant API Gateway Permission to Invoke Lambda
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"  # Permission to invoke Lambda
  principal = "apigateway.amazonaws.com"  # Allow API Gateway to invoke
  function_name = aws_lambda_function.process_text.function_name  # Reference to your Lambda function
  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"  # Reference the API Gateway's ARN
}
# Why: This allows API Gateway to invoke the Lambda function securely.


# 11. Deploy the API Gateway
resource "aws_apigatewayv2_stage" "http_api_stage" {
  api_id = aws_apigatewayv2_api.http_api.id
  name   = "$default" # Stage name (default stage)
  auto_deploy = true # Automatically deploy the API when changes are made
}
# Why: This stage deploys the API Gateway and makes it accessible for requests.

# 12. Useful information for output
# a) Below will output the S3 Bucket URL
output "s3_bucket_url" {
  value = "https://${aws_s3_bucket.serverless_app_bucket.bucket}.s3.amazonaws.com"
  description = "URL of the S3 bucket"
}
# b) Below will output the the API Gateway URL
output "api_gateway_url" {
  value = "${aws_apigatewayv2_api.http_api.api_endpoint}"
  description = "URL of the API Gateway"
}
# Why :The above  will display the URLs of the S3 bucket and API Gateway in the Terraform command prompt once you run 'terraform apply' 
# These outputs make it easy to find the S3 bucket and API Gateway URLs after deployment



