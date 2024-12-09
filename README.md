# Introduction

This guide will walk you through setting up a serverless application in AWS using Terraform. The application will:

- **Receive a POST Request**: An HTTP request will send text data to an API Gateway endpoint.
- **Process the Text**: AWS Lambda will process the received text to find the top 10 most frequent words. Lambda is a serverless compute service that runs code in response to events, without the need to provision or manage servers.
- **Store the Results**: The processed data (top 10 frequent words) will be stored in an S3 bucket as a JSON file. Amazon S3 (Simple Storage Service) is used to store and retrieve any amount of data, including JSON files.
- **Return a URL**: The application will generate a URL that links to the stored JSON file, so you can download the result.


## Understanding the Basics

Before diving into the steps, let’s break down the core concepts.

## Understanding the Basics

Before diving into the steps, let’s break down the core concepts.

1. **Serverless App:**  
   A serverless app means you don’t manage any servers yourself. Instead, AWS automatically runs your code in response to events like an HTTP request. This makes it easier and cheaper to deploy small apps.

2. **POST Request:**  
   A POST request is a way for clients (like your web browser or an app) to send data to a server. The client sends data (in this case, text) to the server, which processes it.

3. **Terraform:**  
   Terraform is a tool that helps you manage cloud infrastructure. With Terraform, you can write configuration files to describe your cloud resources (like AWS Lambda functions and storage), and Terraform will create or modify these resources for you automatically.

4. **JSON File:**  
   A JSON file is a way to store data in a text format that's easy for machines to read. It will be used here to store the list of the most frequent words.

## Installing Terraform on Windows

1. **Download Terraform:**
   - Go to the official Terraform website: [Terraform Downloads](https://www.terraform.io/downloads).
   - Under the **Windows** section, click the appropriate link to download the 64-bit version of Terraform.
   - Once downloaded, unzip the Terraform package to a directory of your choice (e.g., `C:\terraform`).

2. **Add Terraform to the PATH Environment Variable:**
   - Right-click on **This PC** (or **My Computer**) and select **Properties**.
   - Click on **Advanced system settings** and then **Environment Variables**.
   - Under **System Variables**, find the **Path** variable, select it, and click **Edit**.
   - Add the directory where you unzipped Terraform (e.g., `C:\terraform`) to the list of values.
   - Click **OK** to save the changes.

3. **Verify Terraform Installation:**
   - Open **Command Prompt** or **PowerShell** and run the following command:
     ```
     terraform -v
     ```
   - This will show the Terraform version if the installation was successful.

You’re now ready to use Terraform on your Windows machine.


## Setting Up AWS CLI

1. **Download AWS CLI on Windows:**
   - Go to the official AWS CLI download page: [AWS CLI Downloads](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
   - Download the appropriate installer for Windows.
   - Run the installer and follow the prompts to complete the installation.

2. **Verify AWS CLI Installation:**
   - Open **Command Prompt** or **PowerShell**.
   - Run the following command to verify that AWS CLI was installed correctly:
     ```
     aws --version
     ```
   - You should see the version of the AWS CLI installed.

3. **Configure AWS CLI with Your User Key and Secret Key:**
   - To configure AWS CLI, you need your **AWS Access Key ID** and **AWS Secret Access Key**.
     - If you don’t have these credentials, you can create a new user and access keys by following the steps in the [AWS IAM documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html).
   
   - Once you have your credentials, run the following command in **Command Prompt** or **PowerShell**:
     ```
     aws configure
     ```
   - You will be prompted to enter the following information:
     - **AWS Access Key ID**: Enter your AWS Access Key ID.
     - **AWS Secret Access Key**: Enter your AWS Secret Access Key.
     - **Default region name**: Enter the AWS region where you want to deploy resources (e.g., `us-east-1`).
     - **Default output format**: You can choose `json` (default), `text`, or `table` as your output format.

4. **Verify AWS CLI Configuration:**
   - After configuring the AWS CLI, run the following command to verify your setup:
     ```
     aws sts get-caller-identity
     ```
   - This will return the IAM user or role details associated with your AWS credentials, confirming the setup.

Now that AWS CLI is set up, you can interact with AWS services directly from the command line, and Terraform will use this configuration to deploy resources.

## Setting Up Your AWS Account

Before you can use AWS services, you need an AWS account. Here’s how to set one up:

1. **Create an AWS Account:**
   - Visit the [AWS Sign-Up Page](https://aws.amazon.com/).
   - Click on **Create an AWS Account** and follow the prompts to provide your contact information, payment method, and verify your identity.
   - You’ll be prompted to select a support plan (the **Basic Support** plan is free and sufficient for most use cases).
   - After successful registration, AWS will provide you with an account number and access to the AWS Management Console.

2. **Access AWS Management Console:**
   - Once your account is set up, go to [AWS Management Console](https://aws.amazon.com/console/) and log in with your credentials.
   - The Console is where you can manage all your AWS services.

---

## Installing AWS CLI on Windows

The AWS CLI allows you to manage AWS services via command line. Here’s how to install and configure it:

### 1. **Download AWS CLI:**
   - Go to the [AWS CLI Downloads Page](https://aws.amazon.com/cli/).
   - Under the **Windows** section, click the **Windows** installer for your system (64-bit or 32-bit).

### 2. **Install AWS CLI:**
   - After the installer downloads, run the `.msi` file to install the AWS CLI.
   - Follow the installation instructions in the setup wizard to complete the installation.

### 3. **Verify the Installation:**
   - Open **Command Prompt** or **PowerShell** and run the following command to confirm AWS CLI is installed:
     ```
     aws --version
     ```
   - If installed correctly, it will return the installed version of the AWS CLI.

---

## Configuring AWS CLI

Once AWS CLI is installed, you need to configure it with your AWS credentials:

1. **Generate AWS Access Key and Secret Key:**
   - Go to the [IAM Console](https://console.aws.amazon.com/iam/) in AWS.
   - In the left navigation pane, select **Users** and then click on your username.
   - Under the **Security Credentials** tab, find the **Access keys** section and click **Create New Access Key**.
   - Download the **Access Key ID** and **Secret Access Key**. These are your credentials that you’ll use to authenticate AWS CLI.

2. **Configure AWS CLI:**
   - In **Command Prompt** or **PowerShell**, run the following command:
     ```
     aws configure
     ```
   - When prompted, enter the following details:
     - **AWS Access Key ID**: Enter the Access Key ID you generated earlier.
     - **AWS Secret Access Key**: Enter the Secret Access Key you generated earlier.
     - **Default region name**: Enter the default AWS region (e.g., `us-east-1`).
     - **Default output format**: You can leave this as `json` or choose your preferred format.

3. **Verify AWS CLI Configuration:**
   - To confirm that AWS CLI is configured correctly, you can run a test command, such as listing your S3 buckets:
     ```
     aws s3 ls
     ```
   - If configured properly, you will see a list of your S3 buckets (if any), or an empty list.

---

With your AWS account and AWS CLI set up, you’re ready to manage and deploy your AWS resources from the command line!

Here’s the section on preparing the Lambda function code (`count_top_ten_words.py`), including the reasoning for compressing it into a ZIP file:


## Prepare the Lambda Code (count_top_ten_words.py)

The `count_top_ten_words.py` script is where we define the logic for processing the text and extracting the top 10 most frequent words. 

### Review the Code:
- The code defines the logic for reading the input text, counting word frequencies, and generating the output with the top 10 words.
- Detailed comments in the code explain what each part of the script is doing, so you can easily understand and modify it.

### Save and Compress the Code:
Once you’ve reviewed the code and ensured everything looks correct, save the file and compress it into a ZIP file.

### Compressing the Lambda Code:
Run the following command to compress the Python script into a ZIP file:
```
zip count_top_ten_words.zip count_top_ten_words.py
```

### Why Compress the Code:
- **Terraform Deployment**: Lambda functions require the deployment package (your Python code) to be in a ZIP format to upload it to AWS.
- **AWS Lambda**: AWS Lambda only accepts function code in a compressed ZIP file when deploying via the console or CLI. This ensures faster transfers and compatibility with AWS Lambda's execution environment.

This step is crucial to ensure the Lambda function can be deployed successfully on AWS using Terraform.

## Set Up the Infrastructure with Terraform

### Review the `main.tf` File

In the `main.tf` file, we define the AWS resources required for our serverless app. This includes:

- **Lambda Function**: The function to process the text and extract the top 10 most frequent words.
- **API Gateway**: An API Gateway to trigger the Lambda function via a POST request.
- **IAM Role**: The role assigned to the Lambda function for the necessary permissions.
- **S3 Bucket**: The S3 bucket to store the resulting JSON file containing the top 10 frequent words.

You can open the `main.tf` file in any code editor (I used Visual Studio Code), where detailed comments explain each resource. These comments also describe the AWS services used, so you can understand what’s being deployed.

### Execute Terraform Commands

Now, let’s walk through how to execute the Terraform file:

1. **Initialize Terraform**:
   - Run the following command to initialize Terraform and download the necessary provider plugins:
     ```bash
     terraform init
     ```

2. **Validate the Configuration**:
   - This step checks if the configuration files are syntactically correct:
     ```bash
     terraform validate
     ```

3. **Preview the Deployment**:
   - To see what changes Terraform will make to your AWS environment, run:
     ```bash
     terraform plan
     ```
   - Review the plan to ensure that everything looks good before applying the changes.

4. **Apply the Configuration**:
   - To create the AWS resources defined in the `main.tf` file, run:
     ```bash
     terraform apply
     ```
   - Terraform will ask for your approval to proceed with the deployment. Type `yes` to confirm.

5. **View the Resources**:
   - To list all the resources Terraform has created, run:
     ```bash
     terraform state list
     ```

### Output Values

After running `terraform apply`, the `main.tf` file will output the following useful URLs:

- **API Gateway URL**: This is the URL of your API Gateway, which you can use to trigger the Lambda function.
- **S3 Bucket URL**: This is the URL of the S3 bucket where the JSON file with the top 10 most frequent words will be stored.

These output values save you the trouble of manually navigating the AWS Console to find these URLs. You’ll be able to access them directly from your command prompt after running `terraform apply`.

## Test the Application with `sample_request.py`

1. **Update the API Gateway URL**:
   - Open `sample_request.py` and paste the **API Gateway URL** (from Terraform output) into the `GATEWAY_URL` variable.
   
2. **Run the Script**:
   - Run the script with the command:
     ```bash
     python sample_request.py
     ```

3. **Enter Your Text**:
   - Paste the text you want to analyze when prompted.

4. **View the Results**:
   -  The script sends a **POST request** with the text to the API Gateway, which triggers the Lambda function.
   - The response will contain the top 10 frequent words and a URL to a JSON file in your S3 bucket.


This verifies that the Lambda function, API Gateway, and S3 bucket are working correctly.

## Test the Lambda Function in AWS Console

1. **Navigate to Lambda**:
   - Go to the [AWS Console](https://aws.amazon.com/console/) and search for **Lambda**.
   
2. **Select Your Lambda Function**:
   - From the Lambda dashboard, click on your Lambda function, `process_text_lambda`.

3. **Access the Test Section**:
   - In the Lambda function details page, click the **Test** tab to begin testing.

4. **Modify the Test Input**:
   - The default test input will look like this:
     ```json
     {
       "key1": "value1",
       "key2": "value2",
       "key3": "value3"
     }
     ```
   - You need to change it to this format:
     ```json
     {
       "body": "paste your text here"
     }
     ```
   - **Why Change to "body"**: The Lambda function expects the text to be under the `body` field to process it correctly.

5. **Test the Lambda**:
   - After inputting your text in the format above, click **Test**. You’ll see a result notification at the top, and the output will include a **URL** that links to the JSON file in out S3 Bucket containing the top 10 frequent words. 

6. **Download the JSON File**:
   - You can download the resulting JSON file by clicking the provided URL.
  

## **Delete Terraform Resources**

When you're done testing or want to clean up your AWS resources, you can use the `terraform destroy` command to delete the resources managed by Terraform. This is important because it ensures that resources are removed in a controlled manner, preventing unnecessary charges and potential conflicts with future deployments.

To delete all the resources defined in your Terraform configuration, run:
```
terraform destroy
```
This command will prompt you to confirm before proceeding. It will then show a summary of what will be destroyed.

**Important Note:**  
If the S3 bucket you created is not empty, Terraform will fail to delete it. The error message you’ll see is:
```
Error: error deleting S3 Bucket: BucketNotEmpty: The bucket you tried to delete is not empty.
```
To handle this, you can clear the bucket's contents before destroying the resource. To delete the contents of an S3 bucket, run:

```
aws s3 rm s3://sample-s3-bucket --recursive
```
Once the S3 bucket is empty, you can run `terraform destroy` again to remove the bucket itself.

Alternatively, you can use the `force_destroy` argument in your Terraform configuration for the S3 bucket to automatically delete the contents when the bucket is destroyed. Here's how to update your configuration:

```
resource "aws_s3_bucket" "serverless_app_bucket" {
  bucket = "sample-s3-bucket"
  force_destroy = true
}
```
With this configuration, Terraform will delete the contents of the bucket as part of the `terraform destroy` process, avoiding the "BucketNotEmpty" error.




