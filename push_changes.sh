#!/bin/bash

# Check if a commit message was provided
if [ -z "$1" ]; then
  echo "Error: No commit message provided."
  echo "Usage: ./push_changes.sh \"your custom commit message\""
  exit 1
fi

COMMIT_MESSAGE="$1"

# --- Step 1: Submodule Processing ---
echo ">>> Processing submodule: DTensor/Tensor-Implementations"
cd DTensor/Tensor-Implementations || { echo "Error: Could not enter submodule"; exit 1; }

if [[ -n $(git status --porcelain) ]]; then
    echo "Staging and committing submodule changes..."
    git add .
    git commit -m "$COMMIT_MESSAGE"
    git push origin _adhi_merge_
else
    echo "No changes detected in submodule."
fi

# --- Step 2: Parent Repository Processing ---
echo -e "\n>>> Processing parent repository"
cd ../.. || { echo "Error: Could not return to parent directory"; exit 1; }


git add .gitattributes
if [[ -n $(git status --porcelain) ]]; then
    echo "Staging and committing parent repository changes..."
    git add .
    git commit -m "$COMMIT_MESSAGE"


    echo "Pushing parent repository changes to branch TensorParallelism..."
    # Use --force because migrate rewrites the local commit history
    git push origin Tensor_Parallelism --force
else
    echo "No changes detected in parent repository."
fi

