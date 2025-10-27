import os
from dotenv import load_dotenv

load_dotenv()


def greet():
    """Main function that greets the user with their name and masked token."""
    user = os.getenv("USER_NAME", "Anonymous")
    token = os.getenv("API_TOKEN", "No Token")

    # Mask the token for security
    masked_token = token[:4] + "***" if len(token) > 4 else "***"

    return f"Hello {user}, your token is {masked_token}"


def main():
    """Entry point for the application."""
    print(greet())
    print("Application is running successfully!")


if __name__ == "__main__":
    main()
