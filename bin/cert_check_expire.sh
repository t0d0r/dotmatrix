#!/bin/bash

# Check for hostname argument
if [ -z "$1" ]; then
    echo "Usage: $0 hostname"
    exit 1
fi

# Get the hostname from the argument
DOMAIN=$1

# Retrieve the certificate details
CERT_DETAILS=$(echo | openssl s_client -servername "$DOMAIN" -connect "$DOMAIN":443 2>/dev/null | openssl x509 -noout -enddate -issuer)

# Check if the certificate details were retrieved
if [ -z "$CERT_DETAILS" ]; then
    echo "Failed to retrieve the certificate details for $DOMAIN."
    exit 1
fi

# Extract the expiration date and issuer from the certificate details
EXPIRE_DATE=$(echo "$CERT_DETAILS" | grep 'notAfter=' | cut -d= -f2)
ISSUER=$(echo "$CERT_DETAILS" | grep 'issuer=' | cut -d= -f2-)

# Convert the expiration date to seconds since epoch
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    EXPIRE_SECS=$(date -j -f "%b %d %T %Y %Z" "$EXPIRE_DATE" +%s)
else
    # Linux
    EXPIRE_SECS=$(date -d "$EXPIRE_DATE" +%s)
fi

# Current date in seconds since epoch
NOW_SECS=$(date +%s)

# Calculate the difference in days
let DIFF_DAYS=($EXPIRE_SECS - $NOW_SECS)/86400

# Output the results
echo "The SSL certificate for $DOMAIN"
echo "Issuer: $ISSUER"
echo "Expires on: $EXPIRE_DATE."
echo "Days until expiration: $DIFF_DAYS"
