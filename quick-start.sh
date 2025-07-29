#!/bin/bash

# Quick start script for Developer Environment Setup (macOS Apple Silicon)
# This script helps you test the setup and provides examples

echo "🍎 Developer Environment Setup - macOS Apple Silicon"
echo "===================================================="

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
    echo "⚠️  Homebrew not found. The playbook will install it automatically."
else
    echo "✅ Homebrew is installed ($(brew --version | head -n 1))"
fi

# Install Homebrew if not present (required for Ansible installation)
if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
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

# Check if ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo "⚠️  Ansible is not installed. Installing via Homebrew..."
    brew install ansible
    if [ $? -eq 0 ]; then
        echo "✅ Ansible installed successfully"
    else
        echo "❌ Failed to install Ansible"
        exit 1
    fi
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

# Check if Docker is installed
if ls /Applications/Docker.app &> /dev/null; then
    echo "✅ Docker Desktop is already installed"
    # Check if Kubernetes is enabled
    if command -v kubectl &> /dev/null && kubectl cluster-info &> /dev/null; then
        echo "✅ Kubernetes is enabled and running"
    else
        echo "⚠️  Kubernetes not enabled - the playbook will enable it"
    fi
else
    echo "⚠️  Docker Desktop not found - the playbook will install it"
fi

# Check development tools
echo ""
echo "🔧 Checking development tools..."
for tool in pyenv direnv uv make; do
    if command -v $tool &> /dev/null; then
        echo "✅ $tool is installed"
    else
        echo "⚠️  $tool not found - the playbook will install it"
    fi
done

echo ""
echo "🔧 Checking Python development tools..."
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

# Function to run with confirmation (default is Y)
run_with_confirmation() {
    local description=$1
    local command=$2

    echo ""
    echo "📋 $description"
    echo "Command: $command"
    echo ""
    read -p "Do you want to run this? (Y/n): " -n 1 -r
    echo
    # Default to Y if no input
    if [[ -z $REPLY || $REPLY =~ ^[Yy]$ ]]; then
        echo "Running..."
        eval $command
        echo "✅ Done!"
    else
        echo "⏭️  Skipped"
    fi
}

# Test syntax
echo ""
echo "🔍 Testing Ansible playbook syntax..."
ansible-playbook --syntax-check playbook.yml
if [ $? -eq 0 ]; then
    echo "✅ Syntax check passed!"
else
    echo "❌ Syntax check failed!"
    exit 1
fi

echo ""
echo "🎯 Developer Environment Setup Options:"
echo "======================================="

# Offer to run examples
run_with_confirmation "🚀 Complete Developer Environment Setup (Recommended)" \
    "ansible-playbook playbook.yml"

echo ""
echo "🎉 Quick start completed!"
echo "📖 Check README.md for more detailed usage instructions."
echo ""
echo "🍎 Features of this Developer Environment Setup:"
echo "   ✅ Core Development: Xcode CLI Tools, Homebrew, Git, Make"
echo "   ✅ Python Stack: pyenv, Python 3.13, uv, ruff, pytest, pytest-cov, alembic"
echo "   ✅ DevOps Tools: helm, go-task, openapi-generator, Docker Desktop"
echo "   ✅ Environment: direnv for per-project configurations"
echo "   ✅ Communication: Slack for team collaboration"
echo "   ✅ Repository: Your GitHub project ready to develop"
echo "   ✅ Shell integrations configured automatically"
echo "   ✅ Idempotent design - safe to re-run anytime"
echo ""
echo "💡 Tip: You can safely re-run 'ansible-playbook playbook.yml' anytime to:"
echo "   • Restore your environment on a new machine"
echo "   • Update tools and repositories"
echo "   • Ensure everything is properly configured"
echo ""
echo "🐍 Python Development Quick Start:"
echo "   • pyenv global 3.13        # Set Python 3.13 as default (auto-installed)"
echo "   • uv venv                   # Create virtual environment with uv"
echo "   • echo 'source .venv/bin/activate' > .envrc && direnv allow  # Auto-activate venv"
echo "   • ruff check . && ruff format .  # Lint and format code"
echo "   • pytest --cov             # Run tests with coverage"
echo "   • alembic init migrations   # Set up database migrations"
echo ""
echo "🚀 DevOps & Infrastructure Quick Start:"
echo "   • task --list               # See available tasks (Taskfile.yml)"
echo "   • helm repo add stable https://charts.helm.sh/stable  # Add Helm repo"
echo "   • openapi-generator help    # Generate API clients/servers"
echo "   • k9s                       # Interactive Kubernetes dashboard"
echo "   • printf \"1\\nhttps\\nY\\n1\\n\" | gh auth login  # Automated GitHub auth"
echo "   • gh repo list              # List your GitHub repositories"
echo "   • gh repo clone <repo>      # Clone repositories with GitHub CLI"
echo "   • open -a Docker            # Start Docker Desktop"
echo "   • docker --version         # Verify Docker installation"
echo "   • kubectl cluster-info      # Verify Kubernetes is running"
echo "   • kubectl get nodes         # See Kubernetes nodes"
echo "   • docker run hello-world   # Test Docker container" 