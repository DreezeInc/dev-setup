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
echo "💡 Complete the authentication in your browser. The script will wait for you to finish."
echo "💡 If you prefer to skip this step, press Ctrl+C and authenticate later with: gh auth login"
echo ""

# Give user a moment to read the instructions
sleep 3

echo "Starting GitHub CLI authentication..."
echo "🌐 Your browser should open shortly..."
echo ""

# Start GitHub authentication - this will open the browser and wait for completion
printf "1\nhttps\nY\n1\n" | gh auth login

auth_result=$?

echo ""

if [ $auth_result -eq 0 ]; then
    echo "✅ GitHub authentication completed successfully!"
    echo "🎉 You can now clone private repositories and use GitHub CLI features."
else
    echo "⚠️  GitHub authentication was not completed."
    echo "💡 You can complete GitHub authentication later by running:"
    echo "   gh auth login"
    echo "📝 Public repositories will still work without authentication."
fi

echo ""
echo "🔚 GitHub authentication process finished." 