# Trusted-Platform-Module

## GitHub Collaboration Guide

This guide explains how to collaborate effectively on this project using GitHub. As we work together on this Cybersecurity in Embedded Systems course project, following these guidelines will help keep our repository organized and professional.

### Getting Started

1. **Create a GitHub Account**: If you don't already have one, sign up at [github.com](https://github.com)

2. **Install Git**: Download from [git-scm.com](https://git-scm.com/downloads)

3. **Configure Git**:
   Set up your identity so commits are properly attributed to you:

   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

   Make sure to use the same email address as your GitHub account.

4. **Clone the Repository**:

   ```bash
   git clone https://github.com/yannvillellas/Trusted-Platform-Module.git
   cd Trusted-Platform-Module
   ```

5. **Verify Setup**:

   ```bash
   git status
   ```

   You should see a message confirming you're on the main branch.

### Branching Strategy

Always create a new branch for each feature or fix:

1. **Create a branch**:

   ```bash
   git checkout -b feature/your-feature-name
   ```

   Branch naming conventions:

   - `feature/description` - For new features
   - `fix/description` - For bug fixes
   - `docs/description` - For documentation updates
   - `refactor/description` - For code refactoring

   **When working on an issue**, include the issue number in your branch name:

   ```bash
   git checkout -b feature/issue-42-add-key-generation
   ```

2. **Work on your branch**:
   Make changes, add files, and commit regularly

3. **Never work directly on the main branch**

### Conventional Commits

We follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standard for clear and structured commit messages:

```bash
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Common types:

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the code's meaning
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `test`: Adding or correcting tests
- `chore`: Changes to the build process or auxiliary tools

Examples:

```bash
git commit -m "feat: add TPM key generation function"
git commit -m "fix: correct buffer overflow in command parsing"
git commit -m "docs: update installation instructions"
git commit -m "refactor(crypto): optimize RSA key generation"
```

### Workflow Example

```bash
# Get latest changes
git checkout main
git pull

# Create new branch
git checkout -b feature/tpm-command-parser

# Make changes to files...

# Stage changes
git add .

# Commit with conventional format
git commit -m "feat: implement TPM command parser structure"

# Push branch to GitHub
git push -u origin feature/tpm-command-parser
```

### Pull Requests

1. Go to the repository on GitHub
2. Click "Compare & pull request" for your branch
3. Add a clear title and description
4. Link to issues:
   - Include "Closes #X", "Fixes #X", or "Resolves #X" in the PR description, where X is the issue number
   - This will automatically close the linked issue when the PR is merged
   - Example: "Implements TPM command parsing functionality. Closes #3"
5. Request review from team members
6. After approval, merge the pull request

### Keeping Your Branch Updated

```bash
# Switch to main branch
git checkout main

# Pull latest changes
git pull

# Switch back to your feature branch
git checkout feature/your-feature

# Merge changes from main
git merge main
```

### Common Issues and Solutions

- **Merge conflicts**: When Git can't automatically merge changes, you'll need to resolve conflicts manually:

  1. Open the conflicted files
  2. Look for conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
  3. Edit the files to resolve conflicts
  4. Save files, then `git add .` and `git commit`

- **Commit to wrong branch**: If you accidentally commit to the wrong branch:

  ```bash
  git checkout correct-branch
  git cherry-pick commit-hash
  ```

### Need Help?

If you're stuck with any Git operations, don't hesitate to ask for help from the team. Remember, it's better to ask than to risk making mistakes that could affect the repository.

## Project Overview

This repository contains our implementation of a Trusted Platform Module (TPM) simulation in Qemu, focusing on practical command chain implementation and cryptographic key management.

For detailed project specifications, refer to [project-1.md](./project-1.md).
