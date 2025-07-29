#!/bin/bash

# Function to output directly to terminal
output() {
    echo "$@" > /dev/tty
}

output "🔐 GitHub Authentication Starting..."
output "================================"
output ""
output "GitHub CLI (gh) needs to be authenticated to access your repositories."
output "This process will:"
output "  1. Open your web browser"
output "  2. Ask you to sign in to GitHub"
output "  3. Grant permissions to GitHub CLI"
output ""
output "💡 Complete the authentication in your browser. The script will wait for you to finish."
output "💡 If you prefer to skip this step, press Ctrl+C and authenticate later with: gh auth login"
output ""

# Give user a moment to read the instructions
sleep 3

output "Starting GitHub CLI authentication..."
output "🌐 Your browser should open shortly..."
output ""

# Start GitHub authentication - redirect output to terminal so user can see the one-time code
printf "1\nhttps\nY\n1\n" | gh auth login 2>&1 | tee /dev/tty

auth_result=${PIPESTATUS[1]}

output ""

if [ $auth_result -eq 0 ]; then
    output "✅ GitHub authentication completed successfully!"
    output "🎉 You can now clone private repositories and use GitHub CLI features."
else
    output "⚠️  GitHub authentication was not completed."
    output "💡 You can complete GitHub authentication later by running:"
    output "   gh auth login"
    output "📝 Public repositories will still work without authentication."
fi

output ""
output "🔚 GitHub authentication process finished." 