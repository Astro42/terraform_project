# Serverless Text Processor with AWS Lambda, API Gateway, S3, Terraform, and Python

## Step-by-Step Guide to Developing a Serverless App in AWS with Terraform

# **Index**
- **Introduction**
- **Understanding the Basics**

- **Step 1: Download & Install Terraform**
    - 1.1. Download Terraform
    - 1.2. Install Terraform on Windows
    - 1.3. Verify Terraform Installation

- **Step 2: Set Up AWS Environment**
    - 2.1. Create an AWS Account
    - 2.2. Set Up AWS CLI and Terraform
        - 2.2.1. Install AWS CLI
        - 2.2.2. Configure AWS CLI
    - 2.3. Verify AWS CLI

- **Step 4: Configure Terraform with AWS Provider**
    - 4.1. Create a Terraform Project Directory
    - 4.2. Write Your First Terraform Configuration
    - 4.3. Initialize Terraform
    - 4.4. Verify Terraform Configuration
        - 3.4.1. Validate Configuration
        - 3.4.2. Plan Your Infrastructure
        - 3.4.3. Deploy Your Test Infrastructure
    - 4.5. Check if Our Resources Are Deployed Properly
        - 3.5.1. Terraform State
        - 3.5.2. AWS CLI
        - 3.5.3. AWS Resource Explorer
    - 4.6. Delete Terraform Resources
- 

## Introduction
This guide will walk you through setting up a serverless application in AWS using Terraform. The app will:

- Receive a POST request with text.
- Process the text to find the top 10 most frequent words.
- Store the result in a JSON file.
- Return a URL for downloading the file.

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





## **Step 1: Download & Install Terraform**

### 1.1. **Download Terraform**  
Visit the [Terraform download page](https://developer.hashicorp.com/terraform/install#windows) and download the appropriate version for your OS. We will be using Windows for this demo.

### 1.2. **Install Terraform on Windows**
Follow these steps to install and configure it on your Windows machine:
- Extract the `.zip` file to a directory (e.g., `C:\terraform`).
- Add this directory to your system's `Path` environment variable:
    - Right-click **Start**, type "Environment Variables," and select **Edit the system environment variables**.
    - Click **Environment Variables** > **System variables** > **Path** > **Edit** > **New**, and add `C:\terraform`.

### 1.3. **Verify Terraform Installation**
Open **Command Prompt** and type:
```
terraform -v
```
This should display the version of Terraform that was installed. If it shows the version number, you're all set!

---

## **Step 2: Set Up AWS Environment**

### 2.1. **Create an AWS Account**
- Go to the [AWS website](https://aws.amazon.com/) and create an account.
- Follow the steps for entering your personal details and payment method.
- Log into the [AWS Management Console](https://console.aws.amazon.com/).

### 2.2. **Set Up AWS CLI and Terraform**
Before you can use Terraform to create resources on AWS, you need to configure the AWS CLI with your AWS credentials (Access Key and Secret Key).

#### 2.2.1. **Install AWS CLI**
- Visit the [AWS CLI installation page for Windows](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html).
- Download and run the installer.

#### 2.2.2. **Configure AWS CLI**
Open **Command Prompt** as **Administrator** and run the following command in **Command Prompt**:
```
aws configure
```
It will prompt you for the following details:
- **AWS Access Key ID**: You can find this in your [AWS IAM console](https://console.aws.amazon.com/iam/home). If you don’t have one, create a new IAM user with `AdministratorAccess` and note the Access Key ID and Secret Access Key.
- **AWS Secret Access Key**: Same as above.
- **Default region name**: Choose a region close to you, for example, `us-east-1`.
- **Default output format**: You can leave this as `json`.

### 2.3. **Verify AWS CLI**
To verify that AWS CLI is configured properly, run the following:
```
aws sts get-caller-identity
```
This will display your IAM user information.

---

