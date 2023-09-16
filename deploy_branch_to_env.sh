#!/bin/bash

# Commandline arguments
APP_REPO="$1"
DEPLOY_ENV="$2" # e.g., production, staging, development
PATH_TO_REPO="$3"
BRANCH_TO_DEPLOY="$4"

 # Check if git is available
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed."
    exit 1
fi

echo "Check if $APP_REPO, $PATH_TO_REPO, $DEPLOY_ENV are provided"
if [ -z "$APP_REPO" ] || [ -z "$PATH_TO_REPO" ] || [ -z "$DEPLOY_ENV" ]; then
    echo "Error: Missing arguments."
    echo "Usage: $0 <Repo: $1> [Branch:: $BRANCH_TO_DEPLOY] <Env: $3> <Path: $4>"
    exit 1
fi

echo "Set a branch to deploy to main if not provided"
if [ -z "$BRANCH_TO_DEPLOY" ]; then
    echo "Set deploy branch to main"
    BRANCH_TO_DEPLOY="main"  # or "master" or any other default branch name
fi


cd "$PATH_TO_REPO"
echo $(pwd)

echo "Switching to the 'main' branch..."
git checkout main || {
    echo "Error: Failed to checkout the main branch."
    exit 1
}
echo "Git fetch..."
git fetch || {
    echo "Error: Failed to fetch latest changes."
    exit 1
}
echo "Git pull..."
git pull || {
    echo "Error: Failed to pull latest changes."
    exit 1
}
if [ "$BRANCH_TO_DEPLOY" != "main" ]; then
    echo "Switching to the '$BRANCH_TO_DEPLOY' branch..."
    git checkout $BRANCH_TO_DEPLOY || {
        echo "Error: Failed to checkout the $BRANCH_TO_DEPLOY branch."
        exit 1
    }
else
    echo "Already on the 'main' branch. Skipping checkout."
fi

echo "Deploying branch '$BRANCH_TO_DEPLOY' to '$DEPLOY_ENV' environment..."
git push --force origin $BRANCH_TO_DEPLOY:$DEPLOY_ENV || {
    echo "Error: Deploying branch $BRANCH_TO_DEPLOY to $DEPLOY_ENV environment!"
    exit 1
}

echo "Deployment process finished."
