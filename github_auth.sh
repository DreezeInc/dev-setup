#!/bin/bash

echo "🔐 GitHub Authentication Starting..."
echo "================================"
echo ""
echo "Starting GitHub CLI authentication..."
echo ""

# Use expect-like behavior with printf
{
    echo "1"      # GitHub.com
    echo "https"  # HTTPS protocol
    echo "Y"      # Authenticate Git with credentials
    echo "1"      # Login with a web browser
} | gh auth login

echo ""
echo "Authentication process completed." 