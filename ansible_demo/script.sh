#!/bin/bash

# Define AWS access key ID, secret access key, and profile name
access_key_id=""
secret_access_key=""
profile_name="default"

# Set AWS access key ID
aws configure set aws_access_key_id "$access_key_id" --profile "$profile_name"

# Set AWS secret access key
aws configure set aws_secret_access_key "$secret_access_key" --profile "$profile_name"

echo "AWS access key ID and profile configuration completed."
