# Developer Environment Setup - Ansible Playbook (macOS Apple Silicon)

This Ansible playbook sets up a complete developer environment on macOS Apple Silicon by:
- Installing essential development tools (Xcode Command Line Tools, Homebrew, Make)
- Installing Python development tools (pyenv, uv, ruff, pytest, pytest-cov, alembic)
- Installing DevOps & infrastructure tools (helm, go-task, openapi-generator, Docker Desktop)
- Installing environment management tools (direnv)
- Installing Slack for team communication
- Cloning/updating your specified GitHub repository
- Configuring shell integrations for development tools
- Ensuring all operations are idempotent for safe re-runs

## Prerequisites

- macOS running on Apple Silicon (M1/M2/M3)
- Internet connection to access GitHub and download tools
- Admin privileges (for installing development tools)

## Installation

### Install Ansible

**Using Homebrew (recommended):**
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Ansible
brew install ansible
```

**Using pip:**
```bash
# Install Python if not available
brew install python3

# Install Ansible via pip
pip3 install ansible
```

## Usage

### Basic Usage
Run the playbook with default settings (clones the configured repository):
```bash
ansible-playbook playbook.yml
```

### Custom Repository
Specify a different repository URL:
```bash
ansible-playbook playbook.yml -e "repo_url=https://github.com/username/repository.git"
```

### Custom Destination
Specify a different destination path:
```bash
ansible-playbook playbook.yml -e "dest_path=~/projects/my-project"
```

### Specific Branch/Tag
Clone a specific branch or tag:
```bash
ansible-playbook playbook.yml -e "repo_version=develop"
```

### Auto-detect Default Branch
Let the playbook automatically detect the repository's default branch:
```bash
ansible-playbook playbook.yml -e "repo_version=auto"
```

### All Custom Variables
```bash
ansible-playbook playbook.yml \
  -e "repo_url=https://github.com/username/repository.git" \
  -e "dest_path=~/projects/my-project" \
  -e "repo_version=v1.0.0"
```

## Variables

You can customize the following variables:

- `repo_url`: GitHub repository URL (default: https://github.com/DreezeInc/dreeze-git-0.git)
- `dest_path`: Local destination path (default: ~/code/dreeze)
- `repo_version`: Branch, tag, commit hash, or "auto" for auto-detection (default: main)

## What the Playbook Does

1. **Checks for Xcode Command Line Tools** - Essential for git and development on macOS
2. **Installs Xcode Command Line Tools** if not present (will prompt for installation)
3. **Verifies git availability** - Ensures git is working properly
4. **Checks and installs Homebrew** - Package manager for macOS
5. **Updates Homebrew** - Ensures latest package definitions
6. **Checks and installs Slack** - Team communication tool
7. **Checks and installs development tools** - pyenv, direnv, uv, make, jq, helm, go-task, openapi-generator, k9s, gh (GitHub CLI), Docker Desktop
8. **Installs Python development tools** - ruff, pytest, pytest-cov, alembic via uv
9. **Configures shell integrations** - Sets up pyenv and direnv in ~/.zshrc (idempotent)
10. **Installs Python 3.13** - Automatically installs the latest Python version via pyenv
11. **Enables Kubernetes in Docker Desktop** - Automatically configures local Kubernetes cluster
12. **Creates destination directory** - Ensures the target path exists
13. **Auto-detects default branch** (when repo_version="auto") - Handles repos with different default branches
14. **Clones or updates repository** - Downloads or updates the specified GitHub repository
15. **Provides comprehensive status feedback** - Shows what was accomplished

## Idempotency Features

This playbook is designed to be **idempotent**, meaning you can safely run it multiple times:

- ✅ **Safe Re-runs**: Won't break existing installations
- ✅ **Environment Restoration**: Quickly restore your dev environment on a new machine
- ✅ **Updates**: Keeps tools and repositories up to date
- ✅ **Partial Failures**: Can resume from where it left off

### Examples of Idempotent Behavior:
- If Xcode Command Line Tools are already installed → Skips installation
- If Homebrew exists → Just updates it
- If development tools (pyenv, direnv, uv, make, helm, go-task, openapi-generator, Docker Desktop) exist → Skips installation
- If Python tools (ruff, pytest, pytest-cov, alembic) exist → Skips installation
- If shell integrations are configured → Skips configuration
- If Python 3.13 is already installed → Skips Python installation
- If Slack is already installed → Skips installation
- If repository exists → Updates instead of cloning
- If repository is already up to date → No changes made

## File Structure

```
.
├── ansible.cfg                    # Ansible configuration
├── inventory.ini                  # Inventory file
├── playbook.yml                   # Main playbook (Developer environment setup)
├── multiple-repos-example.yml     # Example for multiple repositories
├── quick-start.sh                 # Quick start script
└── README.md                      # This file
```

## Examples

1. **Initial setup on a new machine:**
   ```bash
   ansible-playbook playbook.yml
   ```

2. **Update existing environment:**
   ```bash
   ansible-playbook playbook.yml  # Safe to re-run
   ```

3. **Setup with different repository:**
   ```bash
   ansible-playbook playbook.yml -e "repo_url=https://github.com/apple/swift.git" -e "dest_path=~/projects/swift-source"
   ```

4. **Auto-detect and clone with default branch:**
   ```bash
   ansible-playbook playbook.yml -e "repo_url=https://github.com/microsoft/vscode.git" -e "repo_version=auto"
   ```

5. **Quick start with interactive script:**
   ```bash
   ./quick-start.sh
   ```
   
   The script will ask for your password once at the beginning and cache it for the entire setup duration.

## macOS Apple Silicon Specific Features

- **Automatic Xcode Command Line Tools detection and installation**
- **Native Apple Silicon optimization**
- **Homebrew integration with proper Apple Silicon paths**
- **Slack installation via Homebrew Cask**
- **Smart branch detection** - Automatically handles repos with different default branches
- **Tilde expansion** - Properly handles `~/` paths on macOS

## Branch Handling

The playbook intelligently handles different default branch names:

- **Default**: Uses `main` (modern GitHub default)
- **Auto-detection**: Set `repo_version=auto` to automatically detect the default branch
- **Manual specification**: Specify any branch, tag, or commit hash explicitly

## Developer Environment Features

### Installed Tools:
- **Xcode Command Line Tools** - Git, compilers, and essential development tools
- **Homebrew** - Package manager for additional tools
- **Make** - Build automation tool
- **pyenv** - Python version management with Python 3.13 pre-installed
- **uv** - Fast Python package installer and resolver
- **ruff** - Python linter and code formatter
- **pytest** - Python testing framework
- **pytest-cov** - Test coverage reporting for pytest
- **alembic** - Database migration tool for SQLAlchemy
- **helm** - Kubernetes package manager
- **go-task** - Modern task runner and build tool
- **openapi-generator** - OpenAPI code generation tools
- **k9s** - Interactive Kubernetes CLI dashboard
- **GitHub CLI (gh)** - Official GitHub command line tool
- **Docker Desktop** - Containerization platform with Kubernetes enabled
- **direnv** - Environment variable management per directory
- **Slack** - Team communication and collaboration
- **Your Repository** - Your project code, ready to work with

### Smart Installation:
- **Checks before installing** - Won't reinstall existing tools
- **Updates existing tools** - Keeps everything current
- **Handles failures gracefully** - Can resume partial installations

## Troubleshooting

### Password Handling
The quick-start.sh script now handles password caching automatically. You'll be asked for your password once at the beginning, and it will be cached for the entire setup duration.

This prevents multiple password prompts that would otherwise occur due to:
- Homebrew installations requiring admin privileges
- Installing apps via Homebrew Cask
- Various system configurations needing elevated permissions

The script uses a sudo keep-alive mechanism that refreshes every 60 seconds until the setup completes.

### Branch Not Found Error
If you get a "pathspec did not match" error:
```bash
# Check the repository's default branch on GitHub, then specify it explicitly
ansible-playbook playbook.yml -e "repo_version=main"  # or "master" depending on the repo

# Or use auto-detection
ansible-playbook playbook.yml -e "repo_version=auto"
```

### Xcode Command Line Tools Issues
If you encounter issues with git or development tools:
```bash
# Manually install/update Xcode Command Line Tools
sudo xcode-select --install

# Reset if tools are corrupted
sudo xcode-select --reset
```

### Homebrew Issues
If Homebrew isn't working properly:
```bash
# Reinstall Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add to PATH manually (Apple Silicon)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Git Authentication (for private repositories)

**Automatic GitHub Authentication** - The playbook handles this for you!

1. **Automated Web Browser Authentication** (Default):
   - GitHub CLI is automatically installed and configured
   - Automatically handles all GitHub CLI prompts
   - Opens secure web browser for authentication (no manual input needed)
   - User only needs to complete browser authentication
   - Automatically configures git credentials
   - Works seamlessly with both public and private repositories

2. **Alternative: SSH Keys** (Manual setup):
   ```bash
   # Using SSH (if you prefer manual setup)
   ssh-keygen -t ed25519 -C "your_email@example.com"
   # Add the public key to your GitHub account
   ```

## Notes

- The playbook is optimized for macOS Apple Silicon (M1/M2/M3 chips)
- All installations may require user interaction for permissions
- Repository updates preserve local changes when possible
- The `force: true` option is only used for updates, not initial clones
- Default branch auto-detection helps handle repositories with different naming conventions
- **Idempotent design** allows safe re-runs for environment maintenance
- All operations run locally on your Mac

## Development Workflow

This playbook is perfect for:
- **New machine setup** - Get your dev environment running quickly
- **Environment restoration** - Rebuild after system issues
- **Team onboarding** - Standardize development environments
- **Regular maintenance** - Keep tools and repos updated
- **Experimentation** - Safe to test different configurations 