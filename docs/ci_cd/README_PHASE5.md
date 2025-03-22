# FootballHero CI/CD: Phase 5 - CI/CD Dashboard

This phase implements a comprehensive CI/CD dashboard for visualizing workflow status and project health.

## Components

### Workflows
- `dashboard.yml`: Updates the CI/CD dashboard after workflow runs and on a daily schedule

### Templates
- `dashboard_template.html`: HTML template for the dashboard
- `dashboard_styles.css`: CSS styling for the dashboard

### Configuration
- `dashboard_config.json`: Configuration settings for dashboard generation

## Dashboard Features

The dashboard provides the following information:
- Status of all workflows with success rates
- Build performance metrics
- Pull request statistics
- Visual charts for key metrics

## Viewing the Dashboard

The dashboard is automatically deployed to GitHub Pages. To view it:
1. Go to the repository settings
2. Navigate to the Pages section
3. The dashboard will be available at https://[username].github.io/footballhero/

## Manually Triggering Dashboard Update

1. Go to the Actions tab in GitHub
2. Select the "Update CI/CD Dashboard" workflow
3. Click "Run workflow" and select the branch

## Customizing the Dashboard

To customize the dashboard:
1. Modify `.github/templates/dashboard_template.html` for layout changes
2. Update `.github/templates/dashboard_styles.css` for styling changes
3. Adjust settings in `.github/config/dashboard_config.json` for behavior configuration
