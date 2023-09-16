#!/bin/bash

# Commandline arguments
PATH_TO_REPO="/Users/djamshedkarimov/Desktop/automation/kajabi-products-selenium-tests"
default_branch="main"

 # Check if git is available
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed."
    exit 1
fi

echo "Check if $PATH_TO_REPO are provided"
if [ -z "$PATH_TO_REPO" ]; then
    echo "Error: Missing arguments."
    echo "Usage: $0 Repo_path: $PATH_TO_REPO]"
    exit 1
fi

# Navigate to the directory
cd "$PATH_TO_REPO" || { 
    echo "Directory does not exist"; 
    exit 1; 
}

# Make sure the directory is a git repository
if [ ! -d ".git" ]; then
  echo "This is not a git repository."
  exit 1
fi

# Check for unsaved changes
git diff-index --quiet HEAD || {
  echo "Unsaved changes detected. Stashing changes."
  git stash
  stash_flag=true
}

# Get the current branch name
current_branch=$(git symbolic-ref --short HEAD)

# Check if the current branch is 'main'
if [ "$current_branch" != "$default_branch" ]; then
  git checkout main
fi

echo "Git pull remote main"
git pull origin main || {
    echo "Error: Failed to pull latest changes."
    exit 1
}

# If changes were stashed, apply them back if needed
if [ "$stash_flag" = true ]; then
  echo "Applying stashed changes."
  git stash pop
fi

echo "Pull latest main comolete"
