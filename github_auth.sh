#!/bin/bash

echo "🔐 GitHub Authentication Starting..."
echo "================================"
echo ""
echo "GitHub CLI (gh) needs to be authenticated to access your repositories."
echo "This process will:"
echo "  1. Open your web browser"
echo "  2. Ask you to sign in to GitHub"
echo "  3. Grant permissions to GitHub CLI"
echo ""
echo "⏰ You have 2 minutes to complete the authentication in your browser."
echo "💡 If you prefer to skip this step, press Ctrl+C and authenticate later with: gh auth login"
echo ""

# Give user a moment to read the instructions
sleep 3

echo "Starting GitHub CLI authentication..."
echo "🌐 Your browser should open shortly..."
echo ""

# Set a timeout for the authentication process
timeout 120s bash -c 'printf "1\nhttps\nY\n1\n" | gh auth login  # Automated GitHub auth'

auth_result=$?

echo ""

if [ $auth_result -eq 0 ]; then
    echo "✅ GitHub authentication completed successfully!"
    echo "🎉 You can now clone private repositories and use GitHub CLI features."
elif [ $auth_result -eq 124 ]; then
    echo "⏰ Authentication timed out after 2 minutes."
    echo "💡 You can complete GitHub authentication later by running:"
    echo "   gh auth login"
    echo "📝 Public repositories will still work without authentication."
else
    echo "⚠️  GitHub authentication was not completed."
    echo "💡 You can complete GitHub authentication later by running:"
    echo "   gh auth login"
    echo "📝 Public repositories will still work without authentication."
fi

echo ""
echo "🔚 GitHub authentication process finished." 