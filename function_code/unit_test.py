import pytest
from lambda_function import inputValidator, htmlBuilder, handler

# -----------------------------
# Tests para inputValidator
# -----------------------------
def test_input_validator_empty():
    assert "empty" in inputValidator(None)
    assert "empty" in inputValidator("")
    assert "empty" in inputValidator("   ")

def test_input_validator_valid():
    result = inputValidator("Hello World 123")
    assert result == "is Hello World 123"

def test_input_validator_invalid():
    result = inputValidator("<script>")
    assert "dangerous characters" in result

# -----------------------------
# Tests para htmlBuilder
# -----------------------------
def test_html_builder_contains_message():
    msg = "is TestMessage"
    html = htmlBuilder(msg)
    assert "<html>" in html
    assert msg in html
    assert html.endswith("\n    </html>\n    ")

# -----------------------------
# Tests para handler
# -----------------------------
def test_handler_with_valid_phrase():
    event = {"queryStringParameters": {"phrase": "Hello"}}
    response = handler(event, None)
    assert response["statusCode"] == 200
    assert "is Hello" in response["body"]

def test_handler_with_empty_phrase():
    event = {"queryStringParameters": {"phrase": ""}}
    response = handler(event, None)
    assert "empty" in response["body"]

def test_handler_without_phrase_key():
    event = {"queryStringParameters": {}}
    response = handler(event, None)
    assert "empty" in response["body"]

def test_handler_with_no_query_params():
    event = {}
    response = handler(event, None)
    assert "Please send something" in response["body"]

def test_handler_with_none_event():
    response = handler(None, None)
    assert "was not passed" in response["body"]

def test_handler_with_exception(monkeypatch):
    # Forzar excepción en inputValidator
    def broken_validator(_):
        raise ValueError("Forced error")
    monkeypatch.setattr("lambda_function.inputValidator", broken_validator)

    event = {"queryStringParameters": {"phrase": "Hello"}}
    response = handler(event, None)
    assert "Error detected" in response["body"]
