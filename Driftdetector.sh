#!/bin/bash

# Configuration
TERRAFORM_DIR="terraform/project" 
EMAIL_RECIPIENT="your_email@example.com"  
LOG_FILE="/tmp/terraform_changes.log"      

# Navigate to the Terraform directory
cd "$TERRAFORM_DIR" || { echo "Terraform directory not found."; exit 1; }

# Run terraform refresh
if ! terraform refresh > /dev/null 2>&1; then
    echo "Terraform refresh failed!" | mail -s "Terraform Refresh Failed" "$EMAIL_RECIPIENT"
    exit 1
fi

# Run terraform plan and check for changes
terraform plan -no-color > "$LOG_FILE" 2>&1

if grep -q "No changes" "$LOG_FILE"; then
    echo "No changes detected at $(date)."
else
    mail -s "Terraform Changes Detected" "$EMAIL_RECIPIENT" < "$LOG_FILE"
fi
