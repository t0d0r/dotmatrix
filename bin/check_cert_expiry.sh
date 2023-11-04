#!/bin/bash

# Check for hostname argument
if [ -z "$1" ]; then
    echo "Usage: $0 hostname"
    exit 1
fi

# Get the hostname from the argument
HOSTNAME=$1

# Retrieve the certificate expiration date
EXPIRE_DATE=$(echo | openssl s_client -servername "$HOSTNAME" -connect "$HOSTNAME":443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)

# Check if the expiration date was retrieved
if [ -z "$EXPIRE_DATE" ]; then
    echo "Failed to retrieve the certificate expiration date for $HOSTNAME."
    exit 1
fi

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
echo "The SSL certificate for $HOSTNAME expires on $EXPIRE_DATE."
echo "Days until expiration: $DIFF_DAYS"

