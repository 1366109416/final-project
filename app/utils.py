"""Utility functions for the application."""


def mask_secret(secret, visible_chars=4):
    """Mask a secret string, showing only the first few characters.

    Args:
        secret: The secret string to mask
        visible_chars: Number of characters to show (default: 4)

    Returns:
        Masked string
    """
    if len(secret) <= visible_chars:
        return "***"
    return secret[:visible_chars] + "***"


def validate_env_var(var_name, default=None):
    """Validate and retrieve an environment variable.

    Args:
        var_name: Name of the environment variable
        default: Default value if not found

    Returns:
        Value of the environment variable or default
    """
    import os

    value = os.getenv(var_name, default)
    if value is None:
        raise ValueError(f"Environment variable {var_name} is required but not set")
    return value
