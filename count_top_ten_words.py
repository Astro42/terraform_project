# Import libraries for the job
import json 
import uuid 
import boto3  # Talks to AWS services like S3
import re
from collections import Counter  # Counts how many times a word shows up
import unicodedata  # Handles special characters like accents

# Step 1: Set up the S3 bucket name
# Use an environment variable to make it easy to change later
S3_BUCKET_NAME = "iriusrisk-tech-challenge-bucket-12345"

# Step 2: Define the main function (AWS Lambda will run this)
def count_top_ten_words(event, context):
    # Step 3: Check if we got a body in the request
    if not event.get("body"):
        return {"statusCode": 400, "body": "No text found in the request"}

    try:
        # Step 4: Get the text input and clean it up
        raw_text = event["body"].lower()  # Make everything lowercase for consistency
        
        # Step 5: Remove weird characters (e.g., accents, special symbols)
        cleaned_text = unicodedata.normalize('NFKD', raw_text).encode('ascii', 'ignore').decode('ascii')
        
        # Step 6: Remove punctuation and extra spaces
        cleaned_text = re.sub(r"[^\w\s]", "", cleaned_text)  # Get rid of punctuation
        cleaned_text = re.sub(r"\s+", " ", cleaned_text).strip()  # Fix extra spaces

        # Step 7: Split the cleaned text into individual words
        word_list = cleaned_text.split()

        # Step 8: Find the 10 most common words
        top_words = Counter(word_list).most_common(10)

        # Step 9: Create a JSON file with the results
        result_data = {"top_words": top_words}
        unique_filename = f"{uuid.uuid4()}.json"  # Use UUID to make a unique file name

        # Step 10: Save the JSON file to S3
        s3 = boto3.client("s3")  # Connect to S3
        s3.put_object(
            Bucket=S3_BUCKET_NAME,  # The S3 bucket name
            Key=unique_filename,  # File name in the bucket
            Body=json.dumps(result_data).encode("utf-8"),  # The file content
            ContentType="application/json"  # Let S3 know it's a JSON file
        )

        # Step 11: Create a temporary link for the user to download the file
        download_link = s3.generate_presigned_url(
            "get_object",
            Params={"Bucket": S3_BUCKET_NAME, "Key": unique_filename},  # File details
            ExpiresIn=360  # Link expires in 6 minutes
        )

        # Step 12: Return the download link to the user
        return {
            "statusCode": 200,
            "body": json.dumps({"url": download_link}),
        }

    except Exception as e:
        # Step 13: Handle any errors and return a helpful message
        return {
            "statusCode": 500,
            "body": f"Error: {str(e)}, Received Input: {event.get('body', 'N/A')}"
        }
