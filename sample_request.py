import requests

GATEWAY_URL = "https://fgtne97hc7.execute-api.us-east-1.amazonaws.com" # paste the URL of the API Gateway from terraform
ENDPOINT = "/process_text"

def process_text(text: str):
    # Create the JSON payload with a "body" key containing the text
    session = requests.Session()

    
    # Send the POST request with the corrected payload
    response = session.post(GATEWAY_URL + ENDPOINT, json=text)
    response.raise_for_status()

    download_url = response.json()["url"]
    contents = session.get(download_url).text
    print(contents)
    return download_url

if __name__ == '__main__':
    user_input = input("Enter text here:")

    url = process_text(user_input)
    print(url)
