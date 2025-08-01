#!/bin/bash

# Quick start script for Developer Environment Setup (macOS Apple Silicon)
# This script helps you test the setup and provides examples

echo "🍎 Developer Environment Setup - macOS Apple Silicon"
echo "===================================================="
echo ""

# Setup sudo password caching to avoid multiple prompts
echo "🔐 This setup requires administrator privileges for installing system tools."
echo "   You'll be asked for your password once, and it will be cached for the entire setup."
echo ""

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Store the background job PID
SUDO_PID=$!

# Function to cleanup the sudo keep-alive on exit
cleanup() {
    kill $SUDO_PID 2>/dev/null
}

# Set trap to cleanup on script exit
trap cleanup EXIT

echo "✅ Password cached successfully."
echo ""

# Check if we're on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "❌ This script is designed for macOS only"
    exit 1
fi

# Check if we're on Apple Silicon
if [[ "$(uname -m)" != "arm64" ]]; then
    echo "⚠️  Warning: This script is optimized for Apple Silicon (M1/M2/M3)"
    echo "   You appear to be on Intel Mac ($(uname -m))"
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Exiting"
        exit 1
    fi
fi

echo "✅ Running on macOS $(sw_vers -productVersion) ($(uname -m))"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "⚠️  Homebrew not found. Will be installed after configuration."
else
    echo "✅ Homebrew is installed ($(brew --version | head -n 1))"
fi

# Check if ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo "⚠️  Ansible is not installed. Will be installed after configuration."
else
    echo "✅ Ansible is installed ($(ansible --version | head -n 1))"
fi

# Check Xcode Command Line Tools
echo ""
echo "🔧 Checking development tools..."
if xcode-select -p &> /dev/null; then
    echo "✅ Xcode Command Line Tools are installed"
    echo "   Path: $(xcode-select -p)"
else
    echo "⚠️  Xcode Command Line Tools not found"
    echo "   The playbook will install them automatically"
fi

# Check if Slack is installed
if ls /Applications/Slack.app &> /dev/null; then
    echo "✅ Slack is already installed"
else
    echo "⚠️  Slack not found - the playbook will install it"
fi

# Check if Google Chrome is installed
if ls /Applications/Google\ Chrome.app &> /dev/null; then
    echo "✅ Google Chrome is already installed"
else
    echo "⚠️  Google Chrome not found - the playbook will install it"
fi



# Check development tools
echo ""
echo "🔧 Checking development tools..."
# Add .local/bin to PATH for uv
export PATH="$HOME/.local/bin:$PATH"
for tool in pyenv direnv uv make; do
    if command -v $tool &> /dev/null; then
        echo "✅ $tool is installed"
    else
        echo "⚠️  $tool not found - the playbook will install it"
    fi
done

echo ""
echo "🔧 Checking Python development tools..."
# Add .local/bin to PATH for uv-installed tools
export PATH="$HOME/.local/bin:$PATH"
# Setup pyenv if available
if command -v pyenv &> /dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)" 2>/dev/null || true
fi
for tool in ruff pytest alembic; do
    if command -v $tool &> /dev/null; then
        echo "✅ $tool is installed"
    else
        echo "⚠️  $tool not found - the playbook will install it"
    fi
done

# Check pytest-cov separately since it's a module
if python3 -c "import pytest_cov" 2>/dev/null; then
    echo "✅ pytest-cov is installed"
else
    echo "⚠️  pytest-cov not found - the playbook will install it"
fi

echo ""
echo "🔧 Checking DevOps & Infrastructure tools..."
for tool in helm openapi-generator k9s gh; do
    if command -v $tool &> /dev/null; then
        echo "✅ $tool is installed"
    else
        echo "⚠️  $tool not found - the playbook will install it"
    fi
done

# Check go-task separately since the executable is named 'task'
if command -v task &> /dev/null; then
    echo "✅ go-task (task) is installed"
else
    echo "⚠️  go-task (task) not found - the playbook will install it"
fi



# Test syntax
echo ""
echo "🎯 Setup Configuration"
echo "====================="
echo ""

# Ask all questions upfront
INSTALL_MAIN="n"

echo "This script will set up your developer environment."
echo ""
echo "Main Developer Environment includes:"
echo "   • Xcode CLI Tools, Homebrew, Git, Make"
echo "   • Python Stack: pyenv, Python 3.13, uv, ruff, pytest, alembic"
echo "   • DevOps Tools: helm, go-task, openapi-generator, k9s"
echo "   • Apps: Slack, Google Chrome, Cursor IDE"
echo "   • Your GitHub repository"
echo ""
read -p "Install developer environment? (Y/n): " -n 1 -r
echo
if [[ -z $REPLY || $REPLY =~ ^[Yy]$ ]]; then
    INSTALL_MAIN="y"
fi

echo ""
echo "📋 Configuration Summary:"
echo "========================"
echo "Developer Environment: $([ "$INSTALL_MAIN" == "y" ] && echo "✅ Yes" || echo "❌ No")"
echo ""

if [[ "$INSTALL_MAIN" == "n" ]]; then
    echo "❌ No installation selected. Exiting."
    exit 0
fi

echo ""
echo "🔧 Setting up prerequisites..."
echo ""

# Install Homebrew if not present (required for Ansible installation)
if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew (non-interactively)..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    if command -v brew &> /dev/null; then
        echo "✅ Homebrew installed successfully"
    else
        echo "❌ Failed to install Homebrew"
        exit 1
    fi
fi

# Install Ansible if not present
if ! command -v ansible-playbook &> /dev/null; then
    echo "📦 Installing Ansible via Homebrew..."
    brew install ansible
    if [ $? -eq 0 ]; then
        echo "✅ Ansible installed successfully"
    else
        echo "❌ Failed to install Ansible"
        exit 1
    fi
fi

echo ""
echo "🔍 Testing Ansible playbook syntax..."

if [ "$INSTALL_MAIN" == "y" ]; then
    ansible-playbook --syntax-check playbook.yml
    if [ $? -ne 0 ]; then
        echo "❌ Playbook syntax check failed!"
        exit 1
    fi
fi

echo "✅ Syntax check passed!"
echo ""
echo "🚀 Starting installation..."
echo "This will run unattended. You can safely let it run in the background."
echo ""

# Run the playbook
if [ "$INSTALL_MAIN" == "y" ]; then
    echo "📦 Installing developer environment..."
    ansible-playbook playbook.yml
    if [ $? -ne 0 ]; then
        echo "❌ Environment installation failed!"
        exit 1
    fi
    echo "✅ Developer environment installed successfully!"
    echo ""
fi

echo ""
echo "🎉 Quick start completed!"
echo "📖 Check README.md for more detailed usage instructions."
echo ""
echo "🍎 Features of this Developer Environment Setup:"
echo "   ✅ Core Development: Xcode CLI Tools, Homebrew, Git, Make"
echo "   ✅ Python Stack: pyenv, Python 3.13, uv, ruff, pytest, pytest-cov, alembic"
echo "   ✅ DevOps Tools: helm, go-task, openapi-generator, k9s"
echo "   ✅ Environment: direnv for per-project configurations"
echo "   ✅ Communication: Slack for team collaboration"
echo "   ✅ Browser: Google Chrome"
echo "   ✅ Repository: Your GitHub project ready to develop"
echo "   ✅ Shell integrations configured automatically"
echo "   ✅ Idempotent design - safe to re-run anytime"
echo ""
echo "💡 Tip: You can safely re-run 'ansible-playbook playbook.yml' anytime to:"
echo "   • Restore your environment on a new machine"
echo "   • Update tools and repositories"
echo "   • Ensure everything is properly configured"
echo ""
echo "📚 Tool Usage Examples:"
echo ""
echo "🐍 Python Development:"
echo "   • pyenv list                        # Show available Python versions"
echo "   • pyenv install 3.12                # Install another Python version"
echo "   • pyenv global 3.13                 # Set Python 3.13 as default"
echo "   • pyenv local 3.12                  # Set Python 3.12 for current project"
echo "   • pyenv versions                    # Show installed Python versions"
echo ""
echo "   • uv venv                           # Create virtual environment (fast!)"
echo "   • uv pip install -r requirements.txt # Install dependencies"
echo "   • uv pip install package==1.2.3     # Install specific package version"
echo "   • uv pip list                       # List installed packages"
echo "   • uv pip freeze > requirements.txt  # Export dependencies"
echo ""
echo "   • ruff check .                      # Lint Python code"
echo "   • ruff check . --fix                # Auto-fix linting issues"
echo "   • ruff format .                     # Format Python code"
echo "   • ruff rule E501                    # Show details about a rule"
echo ""
echo "   • pytest                            # Run all tests"
echo "   • pytest tests/test_module.py       # Run specific test file"
echo "   • pytest -v                         # Verbose test output"
echo "   • pytest --cov                      # Run tests with coverage"
echo "   • pytest --cov=mymodule --cov-report=html  # HTML coverage report"
echo "   • pytest -k \"test_name\"             # Run tests matching pattern"
echo "   • pytest -x                         # Stop on first failure"
echo ""
echo "   • alembic init migrations           # Initialize migrations"
echo "   • alembic revision -m \"Add user table\"  # Create new migration"
echo "   • alembic upgrade head              # Apply all migrations"
echo "   • alembic downgrade -1              # Rollback one migration"
echo "   • alembic history                   # Show migration history"
echo ""
echo "🔧 Environment Management:"
echo "   • echo 'layout python' > .envrc     # Auto-activate Python venv"
echo "   • echo 'export API_KEY=secret' >> .envrc  # Set env variables"
echo "   • direnv allow                      # Approve .envrc file"
echo "   • direnv reload                     # Reload environment"
echo "   • direnv status                     # Check direnv status"
echo ""
echo "🐙 GitHub CLI:"
echo "   • gh auth login                     # Authenticate with GitHub"
echo "   • gh auth status                    # Check authentication"
echo "   • gh repo create my-project --public # Create new repository"
echo "   • gh repo clone owner/repo          # Clone repository"
echo "   • gh repo fork owner/repo --clone   # Fork and clone"
echo "   • gh pr create --title \"Fix bug\"    # Create pull request"
echo "   • gh pr list                        # List pull requests"
echo "   • gh issue create --title \"Bug report\" # Create issue"
echo "   • gh workflow run tests.yml         # Trigger GitHub Action"
echo ""
echo "🏗️ Build Tools:"
echo "   • make                              # Run default target"
echo "   • make build                        # Build project"
echo "   • make test                         # Run tests"
echo "   • make clean                        # Clean build artifacts"
echo "   • make help                         # Show available targets"
echo ""
echo "   • task --list                       # List available tasks"
echo "   • task build                        # Run build task"
echo "   • task test                         # Run test task"
echo "   • task --parallel lint test         # Run tasks in parallel"
echo "   • task --watch                      # Watch for changes"
echo ""
echo "🔄 API Development:"
echo "   • openapi-generator list            # List available generators"
echo "   • openapi-generator generate -i api.yaml -g python-flask -o ./server"
echo "   • openapi-generator generate -i api.yaml -g typescript-axios -o ./client"
echo "   • swagger-codegen generate -i api.yaml -l python -o ./client"
echo "   • swagger-codegen config-help -l python  # Show config options"
echo ""

echo "💻 IDE (Cursor):"
echo "   • cursor .                          # Open current directory"
echo "   • cursor file.py                    # Open specific file"
echo "   • cursor --list-extensions          # List installed extensions"
echo "   • cursor --install-extension ext-id # Install extension"
echo ""
echo "🚀 Quick Start Workflow:"
echo "   1. cd ~/code/my-project"
echo "   2. pyenv local 3.13                 # Set Python version"
echo "   3. uv venv                          # Create virtual env"
echo "   4. echo 'source .venv/bin/activate' > .envrc"
echo "   5. direnv allow                     # Auto-activate venv"
echo "   6. uv pip install -r requirements.txt"
echo "   7. ruff check . --fix && ruff format ."
echo "   8. pytest --cov"
echo "   9. cursor .                         # Open in IDE" 