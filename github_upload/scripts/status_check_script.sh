#!/bin/bash
# Script to check the status of CI/CD pipelines

# Set colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "FootballHero CI/CD Status Check"
echo "==============================="

# Get repository information
REPO_OWNER=$(git config --get remote.origin.url | sed -n 's/.*github.com[:/]\([^/]*\)\/\([^/]*\).*/\1/p')
REPO_NAME=$(git config --get remote.origin.url | sed -n 's/.*github.com[:/]\([^/]*\)\/\([^/]*\).*/\2/p' | sed 's/.git//')

if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ]; then
    echo -e "${RED}Error: Could not determine repository information.${NC}"
    echo "Make sure you're running this script from a git repository connected to GitHub."
    exit 1
fi

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${YELLOW}GitHub CLI is not installed. For better results, install it from: https://cli.github.com/${NC}"
    echo "Continuing with limited functionality..."
    HAS_GH=false
else
    HAS_GH=true
    # Check if logged in
    if ! gh auth status &> /dev/null; then
        echo -e "${YELLOW}Please login to GitHub CLI:${NC}"
        gh auth login
    fi
fi

echo -e "\n${GREEN}Checking workflow status...${NC}"

# List of workflows to check
WORKFLOWS=("basic_test.yml" "build.yml" "pr_validation.yml" "release.yml" "scheduled_maintenance.yml")

for workflow in "${WORKFLOWS[@]}"; do
    echo -e "\n${YELLOW}Workflow: ${workflow}${NC}"
    
    if [ "$HAS_GH" = true ]; then
        # Use GitHub CLI to get the latest run
        latest_run=$(gh api -X GET repos/$REPO_OWNER/$REPO_NAME/actions/workflows/$workflow/runs -f per_page=1)
        
        # Extract status and conclusion
        status=$(echo $latest_run | jq -r '.workflow_runs[0].status')
        conclusion=$(echo $latest_run | jq -r '.workflow_runs[0].conclusion')
        created_at=$(echo $latest_run | jq -r '.workflow_runs[0].created_at')
        url=$(echo $latest_run | jq -r '.workflow_runs[0].html_url')
        
        if [ "$status" = "null" ]; then
            echo "  Status: No runs found"
        else
            if [ "$status" = "completed" ]; then
                if [ "$conclusion" = "success" ]; then
                    echo -e "  Status: ${GREEN}Success${NC}"
                else
                    echo -e "  Status: ${RED}Failed${NC}"
                fi
            else
                echo -e "  Status: ${YELLOW}In progress${NC}"
            fi
            echo "  Last run: $created_at"
            echo "  URL: $url"
        fi
    else
        echo "  Install GitHub CLI for workflow status information"
    fi
done

echo -e "\n${GREEN}Checking repository metrics...${NC}"

# Count number of open PRs
if [ "$HAS_GH" = true ]; then
    open_prs=$(gh pr list --state open --json number | jq length)
    echo "Open Pull Requests: $open_prs"
    
    # Get latest release
    latest_release=$(gh api repos/$REPO_OWNER/$REPO_NAME/releases/latest 2>/dev/null || echo '{"tag_name":"None","published_at":"None"}')
    tag=$(echo $latest_release | jq -r '.tag_name')
    date=$(echo $latest_release | jq -r '.published_at')
    
    echo "Latest Release: $tag (Released: $date)"
else
    echo "Install GitHub CLI for repository metrics"
fi

echo -e "\n${YELLOW}Local development environment:${NC}"
# Check Flutter version
if command -v flutter &> /dev/null; then
    flutter_version=$(flutter --version | head -n 1)
    echo "Flutter: $flutter_version"
else
    echo -e "${RED}Flutter not found in PATH${NC}"
fi

# Check Gradle version
if [ -f "android/gradlew" ]; then
    gradle_version=$(cd android && ./gradlew --version | grep Gradle | head -n 1)
    echo "Gradle: $gradle_version"
else
    echo "Gradle: Not found"
fi

echo -e "\n${GREEN}Status check complete.${NC}"