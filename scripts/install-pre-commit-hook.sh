#!/bin/bash

# Script to install pre-commit hook for Ansible syntax checking

HOOK_FILE=".git/hooks/pre-commit"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository root directory"
    echo "Please run this script from the root of your git repository"
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Create the pre-commit hook
cat > "$HOOK_FILE" << 'EOF'
#!/bin/bash

# Pre-commit hook to check Ansible playbook syntax

echo "🔍 Running Ansible syntax check..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if ansible-playbook is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo -e "${YELLOW}⚠️  Warning: ansible-playbook not found in PATH${NC}"
    echo "Install Ansible to enable syntax checking:"
    echo "  pip install ansible"
    echo ""
    echo "Skipping Ansible syntax check..."
    exit 0
fi

# Find all changed .yml and .yaml files
changed_files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(yml|yaml)$')

if [ -z "$changed_files" ]; then
    echo "✅ No Ansible files to check"
    exit 0
fi

# Check syntax for each changed file
syntax_errors=0

# Always check main playbook.yml if it exists and has changes
if [ -f "playbook.yml" ] && echo "$changed_files" | grep -q "playbook.yml"; then
    echo "Checking playbook.yml..."
    if ! ansible-playbook --syntax-check playbook.yml > /tmp/ansible-syntax-check.log 2>&1; then
        echo -e "${RED}❌ Syntax error in playbook.yml:${NC}"
        cat /tmp/ansible-syntax-check.log
        syntax_errors=$((syntax_errors + 1))
    else
        echo -e "${GREEN}✅ playbook.yml syntax OK${NC}"
    fi
fi

# Check other playbook files
for file in $changed_files; do
    # Skip if already checked or if it's not a playbook
    if [ "$file" = "playbook.yml" ]; then
        continue
    fi
    
    # Check if file looks like a playbook (contains 'hosts:' or starts with '---')
    if grep -q "hosts:" "$file" || head -1 "$file" | grep -q "^---"; then
        echo "Checking $file..."
        if ! ansible-playbook --syntax-check "$file" > /tmp/ansible-syntax-check.log 2>&1; then
            echo -e "${RED}❌ Syntax error in $file:${NC}"
            cat /tmp/ansible-syntax-check.log
            syntax_errors=$((syntax_errors + 1))
        else
            echo -e "${GREEN}✅ $file syntax OK${NC}"
        fi
    fi
done

# Clean up
rm -f /tmp/ansible-syntax-check.log

# Exit with error if syntax errors were found
if [ $syntax_errors -gt 0 ]; then
    echo ""
    echo -e "${RED}❌ Commit aborted: $syntax_errors syntax error(s) found${NC}"
    echo -e "${YELLOW}Fix the syntax errors and try again${NC}"
    exit 1
else
    echo -e "${GREEN}✅ All Ansible syntax checks passed${NC}"
fi

exit 0
EOF

# Make the hook executable
chmod +x "$HOOK_FILE"

echo "✅ Pre-commit hook installed successfully!"
echo ""
echo "The hook will automatically check Ansible syntax before each commit."
echo "To bypass the hook (not recommended), use: git commit --no-verify"
echo ""
echo "To uninstall the hook, run: rm $HOOK_FILE"