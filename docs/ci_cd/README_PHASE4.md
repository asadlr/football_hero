# FootballHero CI/CD: Phase 4 - Scheduled Maintenance and Monitoring

This directory contains scripts and templates for the scheduled maintenance and monitoring phase of our CI/CD pipeline.

## Components

### Workflows
- `scheduled_maintenance.yml`: Weekly maintenance workflow that checks dependencies, code quality, and builds nightly versions

### Templates
- `maintenance_report_template.md`: Template for generating maintenance reports

### Scripts
- `status_check_script.sh`: Bash script to check the status of CI/CD pipelines
- `metrics_collector.py`: Python script to collect and process metrics from CI/CD runs

### Documentation
- `monitoring_setup.md`: Documentation on how to set up and access monitoring for the CI/CD pipeline

## Usage

### Running the Status Check Script
```bash
./.github/scripts/status_check_script.sh
```

### Manually Triggering Maintenance
1. Go to the Actions tab in GitHub
2. Select the "Scheduled Maintenance" workflow
3. Click "Run workflow" and select the branch

### Viewing Maintenance Reports
Maintenance reports are uploaded as artifacts after each run of the scheduled maintenance workflow.
