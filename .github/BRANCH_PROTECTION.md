# Branch Protection Configuration

This document describes how to configure branch protection rules in GitHub to require the Ansible syntax check before merging pull requests.

## Setting up Branch Protection

After pushing the GitHub Actions workflow, follow these steps to enable branch protection:

### 1. Navigate to Repository Settings
- Go to your repository on GitHub
- Click on "Settings" tab
- In the left sidebar, click on "Branches" under "Code and automation"

### 2. Add Branch Protection Rule
- Click "Add rule" or "Add branch protection rule"
- In "Branch name pattern", enter your main branch name (e.g., `main`, `master`, or `develop`)

### 3. Configure Protection Settings

Enable the following options:

#### Required Status Checks
- ✅ **Require status checks to pass before merging**
- ✅ **Require branches to be up to date before merging**
- Search for and select: `ansible-syntax-check`

#### Additional Recommended Settings
- ✅ **Require a pull request before merging**
  - ✅ Require approvals (set number as needed)
  - ✅ Dismiss stale pull request approvals when new commits are pushed
  - ✅ Require review from CODEOWNERS (if applicable)
- ✅ **Require conversation resolution before merging**
- ✅ **Include administrators** (optional but recommended)

### 4. Save Changes
Click "Create" or "Save changes" to apply the branch protection rule.

## Verification

After setting up branch protection:

1. The `ansible-syntax-check` workflow will run automatically on:
   - New pull requests that modify Ansible files
   - Pushes to protected branches that modify Ansible files

2. Pull requests will show the status check:
   - ✅ **ansible-syntax-check** — All Ansible playbooks have valid syntax
   - ❌ **ansible-syntax-check** — Syntax errors found (click for details)

3. Merging will be blocked until the syntax check passes

## Workflow Details

The GitHub Actions workflow (`ansible-syntax-check.yml`) performs:
- Ansible installation in CI environment
- Syntax validation of `playbook.yml`
- Automatic discovery and validation of other playbook files
- Clear error reporting if syntax issues are found

## Local Testing

Before pushing changes, you can test locally:
```bash
ansible-playbook --syntax-check playbook.yml
```

## Troubleshooting

If the status check doesn't appear:
1. Ensure the workflow file is in `.github/workflows/`
2. Check that the workflow has run at least once
3. Verify the job name matches: `ansible-syntax-check`
4. Check Actions tab for any workflow errors