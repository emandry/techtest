import re
import logging

def inputValidator(message: str) -> str:
    ############################################################################
    # Function: inputValidator
    # Receives a string a validate just for alphanumeric character and spaces
    # and returns the formatted message
    # Input: string
    # Output: string
    ############################################################################
    if (message is None) or (message.strip() == ""):
        return " is empty. Please send something in the parameter phrase"
    elif re.match(r"^[a-zA-Z0-9\s]+$", message):
        return "is " + message
    else:
        return "contains potentially dangerous characters. Please use only letters, digits and spaces"

def htmlBuilder(message: str) -> str:
    ############################################################################
    # Function: htmlBuilder
    # Receives a validate message a put it on the html
    # Input: string
    # Output: string
    ############################################################################
    return f"""
    <html>
        <head><title>Technical Test</title></head>
        <body>
            <h1>The saved string {message}!</h1>
        </body>
    </html>
    """

def handler(event, context):
    logger = logging.getLogger()
    logger.setLevel(logging.ERROR) # Or logging.ERROR, logging.DEBUG, etc.
    try:
        message = event.get("queryStringParameters", {}).get("phrase", "")
        message = inputValidator(message)
        logger.info(f"Operation succeded")
    except AttributeError:
        message = "was not passed. Please use this example: https://<url>?phrase=Hello"
        logger.error(f"An error occurred: No parameter was passed", exc_info=False)
    except Exception as e: # Catch-all for any other exceptions
        message = " - Error detected processing string. Please check again"
        logger.error(f"An error occurred: {e}", exc_info=True)
    page = htmlBuilder(message)
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "text/html"
        },
        "body": f"{page}"
    } 


