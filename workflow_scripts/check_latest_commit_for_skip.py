import subprocess
import sys

# Define the keyword that should skip the workflow
SKIP_KEYWORDS = ["wip", "skip-ci", "no-build"]

# Function to get the latest commit message
def get_latest_commit_message():
    try:
        # Use subprocess to run the git command and get the output
        commit_message = subprocess.check_output(
            ["git", "log", "-1", "--pretty=%B"], 
            text=True
        ).strip()
        return commit_message
    except subprocess.CalledProcessError as e:
        print(f"Error getting commit message: {e}")
        sys.exit(1)

# Function to check if the commit message contains any skip keyword
def contains_skip_keyword(commit_message, keywords):
    return any(keyword in commit_message for keyword in keywords)

# Main logic
if __name__ == "__main__":
    commit_message = get_latest_commit_message()

    # Output values that can be used in the workflow environment
    if contains_skip_keyword(commit_message, SKIP_KEYWORDS):
        print(f"should_skip={True}") 
    else:
        print(f"should_skip={False}") 
