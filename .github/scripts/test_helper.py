#!/usr/bin/env python3
# test_helper.py - Script to help with test setup and running

import os
import sys
import json
import argparse
import subprocess
from pathlib import Path

def load_component_map():
    """Load the component mapping configuration"""
    map_path = Path('.github/config/ci_component_map.json')
    
    if not map_path.exists():
        print("Error: CI component map not found at", map_path)
        return None
    
    try:
        with open(map_path, 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading component map: {e}")
        return None

def get_changed_files(base_branch='main'):
    """Get list of changed files compared to base branch"""
    try:
        result = subprocess.run(
            ['git', 'diff', '--name-only', base_branch], 
            capture_output=True, 
            text=True
        )
        
        if result.returncode != 0:
            print(f"Error getting changed files: {result.stderr}")
            return []
        
        return [f for f in result.stdout.splitlines() if f.strip()]
    
    except Exception as e:
        print(f"Error checking changed files: {e}")
        return []

def find_affected_tests(changed_files, component_map):
    """Find tests that should be run based on changed files"""
    affected_tests = set()
    
    # Map each changed file to its component
    for changed_file in changed_files:
        for component, info in component_map.get('components', {}).items():
            paths = info.get('paths', [])
            
            for path in paths:
                if path.endswith('/**'):
                    # Handle directory wildcards
                    dir_path = path[:-3]  # Remove '/**'
                    if changed_file.startswith(dir_path):
                        affected_tests.update(info.get('tests', []))
                        break
                elif path == changed_file:
                    # Direct file match
                    affected_tests.update(info.get('tests', []))
                    break
    
    # Check for critical files that should run all tests
    critical_files = component_map.get('critical_files', [])
    for file in changed_files:
        if file in critical_files:
            print(f"Critical file changed: {file}")
            return ['test/']  # Run all tests
    
    return list(affected_tests)

def run_tests(test_paths, coverage=True):
    """Run Flutter tests for given paths"""
    if not test_paths:
        print("No tests to run.")
        return True
    
    success = True
    
    for path in test_paths:
        print(f"Running tests for: {path}")
        
        cmd = ['flutter', 'test', path]
        if coverage:
            cmd.append('--coverage')
        
        result = subprocess.run(cmd)
        
        if result.returncode != 0:
            print(f"Tests failed for {path}")
            success = False
    
    return success

def setup_test_environment():
    """Set up the test environment (create .env file, etc.)"""
    os.makedirs('assets', exist_ok=True)
    
    # Create a simple .env file for tests
    with open('assets/.env', 'w') as f:
        f.write("SUPABASE_URL=https://example.supabase.co\n")
        f.write("SUPABASE_ANON_KEY=example_key\n")
        f.write("ENV=test\n")
        f.write("LOG_INFO=true\n")
        f.write("LOG_WARNING=true\n")
        f.write("LOG_ERROR=true\n")
    
    print("Test environment set up successfully")

def main():
    parser = argparse.ArgumentParser(description='Flutter test helper script')
    parser.add_argument('--all', action='store_true', help='Run all tests')
    parser.add_argument('--component', help='Run tests for specific component')
    parser.add_argument('--changed', action='store_true', help='Run tests based on changed files')
    parser.add_argument('--base', default='main', help='Base branch for comparison (default: main)')
    parser.add_argument('--no-coverage', action='store_true', help='Disable coverage reporting')
    parser.add_argument('--setup-env', action='store_true', help='Set up test environment')
    
    args = parser.parse_args()
    
    # Load component map
    component_map = load_component_map()
    if not component_map:
        sys.exit(1)
    
    # Set up environment if requested
    if args.setup_env:
        setup_test_environment()
    
    # Determine which tests to run
    test_paths = []
    
    if args.all:
        test_paths = ['test/']
    
    elif args.component:
        component = args.component.lower()
        if component in component_map.get('test_mapping', {}):
            test_paths = component_map['test_mapping'][component]
        else:
            print(f"Unknown component: {component}")
            print("Available components:", list(component_map.get('test_mapping', {}).keys()))
            sys.exit(1)
    
    elif args.changed:
        changed_files = get_changed_files(args.base)
        print("Changed files:")
        for f in changed_files:
            print(f"  {f}")
        
        test_paths = find_affected_tests(changed_files, component_map)
    
    else:
        # No test selection provided
        parser.print_help()
        sys.exit(1)
    
    print("\nTests to run:")
    for path in test_paths:
        print(f"  {path}")
    
    # Run the tests
    success = run_tests(test_paths, coverage=not args.no_coverage)
    
    if not success:
        sys.exit(1)

if __name__ == "__main__":
    main()
