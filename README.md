# Serverless Text Processing Application

This is a serverless application designed to process text input, identify the top 10 most frequent words, and store the result in an S3 bucket. It utilizes AWS services such as Lambda, S3, IAM, and API Gateway.

## Project Overview

The application provides an HTTP endpoint where users can submit text. The backend, powered by AWS Lambda, processes the text and stores the top 10 frequent words in a JSON file on an S3 bucket. A pre-signed URL is generated for downloading the result.

### AWS Services Used

- **AWS Lambda**: To process the text input and interact with other AWS services.
- **AWS S3**: To store the JSON output containing the top 10 words.
- **AWS API Gateway**: To expose the Lambda function as a RESTful API.
- **IAM Roles and Policies**: For securing and allowing appropriate permissions between Lambda and S3.

## How It Works

### Step 1: Deploy the Infrastructure with Terraform
The infrastructure is defined in the `main.tf` file using Terraform. The deployment consists of:

1. **AWS Provider**: Specifies the AWS region for resources.
2. **S3 Bucket**: A bucket to store the output JSON file.
3. **Lambda Function**: Processes the text and stores the results in the S3 bucket.
4. **API Gateway**: Exposes a POST endpoint to interact with the Lambda function.
5. **IAM Roles**: Necessary for Lambda's access to S3 and API Gateway.

### Step 2: Lambda Function
The `count_top_ten_words.py` script is the core of the Lambda function. It performs the following tasks:

- Accepts a POST request with raw text.
- Cleans and processes the text to remove special characters and punctuation.
- Identifies the 10 most frequent words.
- Stores the result as a JSON file in an S3 bucket.

### Step 3: Requesting Text Processing

The `sample_request.py` file is used to test the API by sending a POST request to the API Gateway endpoint with the text. Once the Lambda function processes the text, it returns a download URL for the JSON file containing the top 10 words.

## Prerequisites

- **Terraform**: To deploy the AWS infrastructure.
- **AWS CLI**: For configuring your AWS credentials.
- **Python 3.x**: To run the Lambda function and test it locally.

## Setup and Deployment

1. Clone this repository to your local machine.
2. Install Terraform and AWS CLI, and configure them with your AWS credentials.
3. Initialize Terraform:
   ```bash
   terraform init
