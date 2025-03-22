#!/usr/bin/env python3
# generate_dashboard.py - Generate CI/CD dashboard for FootballHero

import os
import sys
import json
import datetime
import matplotlib.pyplot as plt
from github import Github
import pandas as pd
import jinja2

def setup_environment():
    """Ensure dashboard output directory exists"""
    os.makedirs('dashboard', exist_ok=True)
    
    # Copy static assets
    import shutil
    shutil.copy('.github/templates/dashboard_styles.css', 'dashboard/styles.css')

def get_github_actions_data(repo):
    """Retrieve GitHub Actions workflow run data"""
    try:
        workflows = repo.get_workflows()
        workflow_runs = []

        for workflow in workflows:
            recent_runs = workflow.get_runs()
            for run in recent_runs:
                workflow_runs.append({
                    'workflow_name': workflow.name,
                    'status': run.status,
                    'conclusion': run.conclusion,
                    'created_at': run.created_at,
                    'updated_at': run.updated_at,
                    'run_number': run.run_number,
                    'run_url': run.html_url,
                    'event': run.event
                })
        
        return pd.DataFrame(workflow_runs)
    except Exception as e:
        print(f"Error retrieving workflow data: {e}")
        return pd.DataFrame()

def generate_workflow_status_chart(df):
    """Create a pie chart of workflow statuses"""
    try:
        status_counts = df['conclusion'].value_counts()
        plt.figure(figsize=(10, 6))
        plt.pie(status_counts, labels=status_counts.index, autopct='%1.1f%%')
        plt.title('GitHub Actions Workflow Statuses')
        plt.tight_layout()
        plt.savefig('dashboard/workflow_status.png')
        plt.close()
    except Exception as e:
        print(f"Error generating workflow status chart: {e}")

def generate_workflow_timeline(df):
    """Create a timeline of workflow runs"""
    try:
        df_sorted = df.sort_values('created_at')
        plt.figure(figsize=(12, 6))
        plt.scatter(df_sorted['created_at'], df_sorted['run_number'], 
                    c=df_sorted['conclusion'].map({'success': 'green', 'failure': 'red', 'skipped': 'gray'}))
        plt.title('Workflow Runs Timeline')
        plt.xlabel('Date')
        plt.ylabel('Run Number')
        plt.xticks(rotation=45)
        plt.tight_layout()
        plt.savefig('dashboard/workflow_timeline.png')
        plt.close()
    except Exception as e:
        print(f"Error generating workflow timeline chart: {e}")

def generate_dashboard(repo):
    """Generate the complete dashboard"""
    # Setup dashboard directory
    setup_environment()
    
    # Collect data
    actions_df = get_github_actions_data(repo)
    
    # Generate charts
    generate_workflow_status_chart(actions_df)
    generate_workflow_timeline(actions_df)
    
    # Create a simple HTML fallback if charts fail
    with open('dashboard/index.html', 'w') as f:
        f.write("""
        <!DOCTYPE html>
        <html>
        <head><title>FootballHero CI/CD Dashboard</title></head>
        <body>
            <h1>FootballHero CI/CD Dashboard</h1>
            <p>Dashboard generation in progress...</p>
        </body>
        </html>
        """)

def main():
    # Get GitHub token from environment
    github_token = os.environ.get('GITHUB_TOKEN')
    if not github_token:
        print("Error: GITHUB_TOKEN environment variable not set")
        sys.exit(1)
    
    # Initialize GitHub connection
    g = Github(github_token)
    repo = g.get_repo('asadlr/football_hero')
    
    generate_dashboard(repo)
    print("Dashboard generated successfully in 'dashboard' directory")

if __name__ == "__main__":
    main()
