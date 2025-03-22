# FootballHero CI/CD: Phase 6 - Continuous Integration for Core Components

This phase implements specialized continuous integration workflows for testing core components of the application.

## Components

### Workflows
- `core_components.yml`: Tests core components (models, screens, widgets, theme, state)
- `integration_test.yml`: Runs integration tests on an Android emulator
- `role_based_testing.yml`: Tests role-specific functionality
- `performance_test.yml`: Measures application performance

### Configuration
- `ci_component_map.json`: Maps code paths to test requirements

### Scripts
- `test_helper.py`: Utility script for running tests based on changed files

## Key Features

### Component-Based Testing
The CI pipeline intelligently determines which components have changed and runs only the relevant tests, saving time and resources.

### Integration Testing
Integration tests are run on real Android emulators to verify that screens and widgets work together correctly.

### Role-Based Testing
Specialized tests for each user role ensure that role-specific features work correctly.

### Performance Testing
Regular performance tests help catch performance regressions early.

## Using the Test Helper

The test helper script can be used locally to run tests for specific components or based on changed files:

```bash
# Run all tests
python .github/scripts/test_helper.py --all

# Run tests for a specific component
python .github/scripts/test_helper.py --component models

# Run tests based on changed files
python .github/scripts/test_helper.py --changed

# Set up test environment
python .github/scripts/test_helper.py --setup-env
```

## Manually Triggering Workflows

Each workflow can be manually triggered from the GitHub Actions tab. This is useful for:
- Running tests after fixing issues
- Testing specific components without pushing code
- Running performance tests before merging important changes

## Viewing Test Results

After tests run, results are uploaded as artifacts and can be accessed from the GitHub Actions tab.
