# FootballHero Monitoring Setup

This document explains how to access and configure monitoring for the FootballHero CI/CD pipeline.

## GitHub Actions Dashboard

### Accessing Workflow Runs
1. Go to the [Actions tab](https://github.com/your-org/footballhero/actions) in the repository
2. Select the workflow you want to monitor
3. View detailed logs and metrics for each run

### Setting Up Notifications

#### Email Notifications
Email notifications are configured in the `scheduled_maintenance.yml` workflow:
- They are sent to addresses configured in the `DEVOPS_EMAIL` secret
- They include status summaries of all maintenance tasks
- Frequency: Weekly (after scheduled maintenance runs)

To modify email recipients:
1. Go to repository Settings > Secrets > Actions
2. Update the `DEVOPS_EMAIL` secret with comma-separated email addresses

#### Slack Notifications
Slack notifications are configured through a webhook:
1. The webhook URL is stored in the `SLACK_WEBHOOK_URL` secret
2. Notifications are sent after maintenance runs and on workflow failures
3. They include direct links to the workflow runs

To set up Slack notifications for your team:
1. Create a Slack app in your workspace
2. Add an Incoming Webhook integration
3. Copy the webhook URL
4. Add it as a secret named `SLACK_WEBHOOK_URL` in the repository

## Monitoring Critical Metrics

### Build Health
- **Where to find it**: In the Actions tab, look for the success/failure rate of recent workflow runs
- **Alert threshold**: Three consecutive failures triggers an alert
- **How to fix common issues**: See troubleshooting section in CICD_DASHBOARD.md

### Test Coverage
- **Where to find it**: In workflow artifacts, download the coverage report
- **Minimum threshold**: 80% overall coverage
- **How to improve**: Focus on adding tests for uncovered code paths

### Performance Metrics
- **Where to find it**: Performance reports are uploaded as artifacts in the `scheduled_maintenance.yml` workflow
- **Baseline**: Initial benchmark set on April 1, 2023
- **Alert threshold**: 20% degradation from baseline

## Setting Up Local Monitoring

To monitor the CI/CD pipeline locally:
1. Clone the repository
2. Run the status check script:
```bash
./.github/scripts/status_check_script.sh
```
3. This will output the current status of all workflows and latest metrics

## Log Retention

- Workflow logs are retained for 90 days in GitHub Actions
- Artifacts from maintenance runs are kept for 30 days
- Historical metrics are saved to a JSON file in the repository for long-term tracking
