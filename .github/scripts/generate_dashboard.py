"""
generate_dashboard.py - Advanced CI/CD Dashboard Generator for FootballHero

This script provides a comprehensive dashboard for tracking GitHub Actions workflows,
project health, and CI/CD performance metrics.

Key Features:
- Detailed workflow run analysis
- Performance trend visualization
- Comprehensive error tracking
- HTML dashboard generation
- Static assets management
"""

import os
import sys
import json
import logging
import datetime
from typing import Dict, List, Optional

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from github import Github, GithubException
from jinja2 import Environment, FileSystemLoader

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('dashboard_generator.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

class DashboardGenerator:
    """
    Comprehensive dashboard generator for FootballHero CI/CD metrics
    """
    def __init__(self, github_token: str, repo_name: str):
        """
        Initialize dashboard generator with GitHub credentials
        
        Args:
            github_token (str): GitHub authentication token
            repo_name (str): Repository name in 'owner/repo' format
        """
        try:
            self.github = Github(github_token)
            self.repo = self.github.get_repo(repo_name)
            self.dashboard_dir = 'dashboard'
            
            # Ensure dashboard directory exists
            os.makedirs(self.dashboard_dir, exist_ok=True)
        except GithubException as e:
            logger.error(f"GitHub authentication failed: {e}")
            raise

    def collect_workflow_data(self) -> pd.DataFrame:
        """
        Retrieve and process GitHub Actions workflow run data
        
        Returns:
            pd.DataFrame: Processed workflow run data
        """
        try:
            # List to store workflow runs
            workflow_runs = []

            # Get all workflows for the repository
            workflows = list(self.repo.get_workflows())
            logger.info(f"Found {len(workflows)} workflows in the repository")

            # Iterate through workflows with additional error handling
            for workflow in workflows:
                try:
                    # Limit to most recent 50 runs to prevent excessive API calls
                    recent_runs = list(workflow.get_runs(status='completed')[:50])
                    logger.info(f"Processing workflow: {workflow.name}, Found {len(recent_runs)} completed runs")

                    for run in recent_runs:
                        try:
                            workflow_runs.append({
                                'workflow_name': workflow.name,
                                'status': run.status,
                                'conclusion': run.conclusion,
                                'created_at': run.created_at,
                                'updated_at': run.updated_at,
                                'run_number': run.run_number,
                                'run_url': run.html_url,
                                'event': run.event,
                                'actor': run.actor.login if run.actor else 'Unknown',
                                'duration': (run.updated_at - run.created_at).total_seconds()
                            })
                        except Exception as run_error:
                            logger.warning(f"Error processing run in workflow {workflow.name}: {run_error}")

                except Exception as workflow_error:
                    logger.warning(f"Error retrieving runs for workflow {workflow.name}: {workflow_error}")

            # Create DataFrame
            if not workflow_runs:
                logger.warning("No workflow runs found")
                return pd.DataFrame()

            df = pd.DataFrame(workflow_runs)
            df['created_at'] = pd.to_datetime(df['created_at'])
            
            logger.info(f"Successfully collected {len(df)} workflow runs")
            return df

        except GithubException as github_error:
            # Specific handling for GitHub API errors
            logger.error(f"GitHub API Error: {github_error}")
            logger.error(f"Error Code: {github_error.status}")
            logger.error(f"Error Message: {github_error.data}")
            return pd.DataFrame()
        except Exception as e:
            # Catch-all for any unexpected errors
            logger.error(f"Unexpected error in collect_workflow_data: {e}")
            logger.error(f"Error Type: {type(e).__name__}")
            
            # Log the full traceback for debugging
            import traceback
            logger.error(traceback.format_exc())
            
            return pd.DataFrame()

    def generate_workflow_status_chart(self, df: pd.DataFrame):
        """
        Create workflow status pie chart with additional context
        
        Args:
            df (pd.DataFrame): Workflow run data
        """
        try:
            plt.figure(figsize=(12, 8))
            status_counts = df['conclusion'].value_counts()
            colors = {
                'success': '#2ecc71',   # Green
                'failure': '#e74c3c',   # Red
                'skipped': '#95a5a6',   # Gray
                'cancelled': '#f39c12'  # Orange
            }
            
            color_palette = [colors.get(status, '#3498db') for status in status_counts.index]
            
            plt.pie(
                status_counts, 
                labels=status_counts.index, 
                autopct='%1.1f%%',
                colors=color_palette,
                startangle=90
            )
            plt.title('FootballHero GitHub Actions Workflow Statuses', fontsize=15)
            plt.axis('equal')
            plt.tight_layout()
            plt.savefig(os.path.join(self.dashboard_dir, 'workflow_status.png'), dpi=300)
            plt.close()
        except Exception as e:
            logger.error(f"Error generating workflow status chart: {e}")

    def generate_workflow_timeline(self, df: pd.DataFrame):
        """
        Create an advanced timeline of workflow runs with color-coded performance
        
        Args:
            df (pd.DataFrame): Workflow run data
        """
        try:
            plt.figure(figsize=(15, 8))
            
            # Set default color map with robust handling
            def get_color(status):
                color_map = {
                    'success': '#2ecc71',   # Green
                    'failure': '#e74c3c',   # Red
                    'skipped': '#95a5a6',   # Gray
                    'cancelled': '#f39c12'  # Orange
                }
                # Convert to string and lowercase to handle potential type variations
                status_str = str(status).lower()
                return color_map.get(status_str, '#3498db')  # Default to blue if status not found
            
            df_sorted = df.sort_values('created_at')
            
            # Fill NaN values with 'unknown' to avoid plotting issues
            df_sorted['conclusion'] = df_sorted['conclusion'].fillna('unknown')
            
            # Convert conclusions to strings
            df_sorted['conclusion'] = df_sorted['conclusion'].astype(str)
            
            scatter = plt.scatter(
                df_sorted['created_at'], 
                df_sorted['run_number'],
                c=[get_color(status) for status in df_sorted['conclusion']],
                alpha=0.7,
                s=100  # Increased marker size
            )
            
            plt.title('FootballHero Workflow Runs Timeline', fontsize=15)
            plt.xlabel('Date', fontsize=12)
            plt.ylabel('Run Number', fontsize=12)
            plt.xticks(rotation=45)
            plt.grid(True, linestyle='--', linewidth=0.5)
            plt.tight_layout()
            plt.savefig(os.path.join(self.dashboard_dir, 'workflow_timeline.png'), dpi=300)
            plt.close()
        except Exception as e:
            logger.error(f"Error generating workflow timeline chart: {e}")
            # Create a placeholder image if chart generation fails
            plt.figure(figsize=(15, 8))
            plt.text(0.5, 0.5, 'Unable to Generate Timeline', 
                     horizontalalignment='center', 
                     verticalalignment='center', 
                     fontsize=15, 
                     color='red')
            plt.axis('off')
            plt.tight_layout()
            plt.savefig(os.path.join(self.dashboard_dir, 'workflow_timeline.png'), dpi=300)
            plt.close()

    def generate_workflow_performance_metrics(self, df: pd.DataFrame):
        """
        Generate workflow performance metrics JSON
        
        Args:
            df (pd.DataFrame): Workflow run data
        """
        try:
            # Calculate performance metrics
            # Robust metrics calculation with error handling
            metrics = {
                'total_runs': len(df),
                'success_rate': round((df['conclusion'] == 'success').mean() * 100, 2),
                'average_run_duration': round(df['duration'].mean(), 2) if not df['duration'].empty else 0,
                'most_frequent_workflow': df['workflow_name'].mode().values[0] if not df['workflow_name'].empty else 'N/A',
                'workflow_breakdowns': df['workflow_name'].value_counts().to_dict(),
                'recent_performance': {}
            }
            
            # Convert date-based performance to string keys
            performance_by_date = df.groupby(df['created_at'].dt.date)['conclusion'].apply(
                lambda x: round((x == 'success').mean() * 100, 2)
            )
            
            # Convert date keys to string
            metrics['recent_performance'] = {
                str(date): float(rate) for date, rate in performance_by_date.items()
            }

            with open(os.path.join(self.dashboard_dir, 'workflow_metrics.json'), 'w') as f:
                json.dump(metrics, f, indent=4, default=str)
        except Exception as e:
            logger.error(f"Error generating workflow performance metrics: {e}")
            # Log the full traceback for debugging
            import traceback
            logger.error(traceback.format_exc())

    def generate_html_dashboard(self):
        """
        Generate an HTML dashboard using Jinja2 templating
        """
        try:
            # Setup Jinja2 environment
            env = Environment(loader=FileSystemLoader('.github/templates'))
            template = env.get_template('dashboard_template.html')

            # Read metrics with error handling
            metrics_path = os.path.join(self.dashboard_dir, 'workflow_metrics.json')
            if not os.path.exists(metrics_path):
                logger.error(f"Metrics file not found: {metrics_path}")
                return

            try:
                with open(metrics_path, 'r') as f:
                    metrics = json.load(f)
            except json.JSONDecodeError as e:
                logger.error(f"Error parsing JSON: {e}")
                # Optionally, create a default metrics dictionary
                metrics = {
                    'total_runs': 0,
                    'success_rate': 0,
                    'average_run_duration': 0,
                    'most_frequent_workflow': 'N/A',
                    'workflow_breakdowns': {},
                    'recent_performance': {}
                }

            # Create default PR stats
            pr_stats = {
                'open_count': 0,
                'avg_merge_time': 0,
                'open_prs': []
            }

            # Get current timestamp
            current_timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S UTC")

            # Render template
            html_output = template.render(
                title='FootballHero CI/CD Dashboard',
                current_timestamp=current_timestamp,
                metrics=metrics,
                pr_stats=pr_stats,
                workflow_status_chart='workflow_status.png',
                workflow_timeline_chart='workflow_timeline.png'
            )

            # Write HTML
            with open(os.path.join(self.dashboard_dir, 'index.html'), 'w') as f:
                f.write(html_output)
        except Exception as e:
            logger.error(f"Error generating HTML dashboard: {e}")
            # Log full traceback for detailed debugging
            import traceback
            logger.error(traceback.format_exc())

    def run(self):
        """
        Execute complete dashboard generation process
        """
        try:
            # Collect workflow data
            workflow_df = self.collect_workflow_data()

            if workflow_df.empty:
                logger.warning("No workflow data collected. Skipping dashboard generation.")
                return

            # Generate visualizations
            self.generate_workflow_status_chart(workflow_df)
            self.generate_workflow_timeline(workflow_df)
            
            # Generate metrics
            self.generate_workflow_performance_metrics(workflow_df)
            
            # Create HTML dashboard
            self.generate_html_dashboard()

            logger.info("Dashboard generated successfully in 'dashboard' directory")
        except Exception as e:
            logger.error(f"Dashboard generation failed: {e}")

def main():
    """
    Main entry point for dashboard generation
    """
    # Get GitHub token from environment
    github_token = os.environ.get('GITHUB_TOKEN')
    if not github_token:
        logger.error("Error: GITHUB_TOKEN environment variable not set")
        sys.exit(1)

    try:
        dashboard_generator = DashboardGenerator(
            github_token=github_token, 
            repo_name='asadlr/football_hero'
        )
        dashboard_generator.run()
    except Exception as e:
        logger.error(f"Fatal error in dashboard generation: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()