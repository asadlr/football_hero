#!/usr/bin/env python3
# metrics_collector.py - Collects and processes metrics from CI/CD runs

import os
import sys
import json
import datetime
import argparse
from pathlib import Path

def collect_test_metrics(coverage_file):
    """
    Parse and collect test coverage metrics from coverage report
    """
    metrics = {
        "total_coverage": 0,
        "coverage_by_package": {},
        "uncovered_files": []
    }
    
    if not os.path.exists(coverage_file):
        print(f"Warning: Coverage file {coverage_file} not found")
        return metrics
    
    try:
        with open(coverage_file, 'r') as f:
            coverage_data = json.load(f)
            
        # Extract overall coverage
        total_lines = 0
        covered_lines = 0
        
        for file_data in coverage_data.get('coverage', {}).values():
            file_total = sum(1 for hit in file_data.values() if hit is not None)
            file_covered = sum(1 for hit in file_data.values() if hit is not None and hit > 0)
            
            total_lines += file_total
            covered_lines += file_covered
        
        if total_lines > 0:
            metrics["total_coverage"] = round((covered_lines / total_lines) * 100, 2)
            
        # TODO: Add package-level metrics and uncovered files list
            
    except Exception as e:
        print(f"Error parsing coverage data: {e}")
    
    return metrics

def collect_dependency_metrics(outdated_file):
    """
    Parse output from 'flutter pub outdated' to collect dependency metrics
    """
    metrics = {
        "outdated_packages": 0,
        "major_updates": 0,
        "minor_updates": 0,
        "patch_updates": 0,
        "packages": []
    }
    
    if not os.path.exists(outdated_file):
        print(f"Warning: Outdated packages file {outdated_file} not found")
        return metrics
    
    try:
        with open(outdated_file, 'r') as f:
            lines = f.readlines()
            
        parsing_table = False
        for line in lines:
            if "Package Name" in line and "Current" in line and "Latest" in line:
                parsing_table = True
                continue
            
            if parsing_table and line.strip() and not line.startswith("Package Name"):
                metrics["outdated_packages"] += 1
                
                parts = [p.strip() for p in line.split("|") if p.strip()]
                if len(parts) >= 4:
                    package_name = parts[0]
                    current = parts[1] if len(parts) > 1 else "unknown"
                    latest = parts[3] if len(parts) > 3 else "unknown"
                    
                    metrics["packages"].append({
                        "name": package_name,
                        "current": current,
                        "latest": latest
                    })
                    
                    # Determine update type if versions follow semver
                    try:
                        if current != "unknown" and latest != "unknown":
                            current_parts = current.split('.')
                            latest_parts = latest.split('.')
                            
                            if latest_parts[0] > current_parts[0]:
                                metrics["major_updates"] += 1
                            elif latest_parts[1] > current_parts[1]:
                                metrics["minor_updates"] += 1
                            elif latest_parts[2] > current_parts[2]:
                                metrics["patch_updates"] += 1
                    except:
                        # Skip version comparison if format is unexpected
                        pass
    
    except Exception as e:
        print(f"Error parsing dependency data: {e}")
    
    return metrics

def collect_build_metrics(performance_file):
    """
    Parse performance metrics from build process
    """
    metrics = {
        "total_build_time": 0,
        "compile_time": 0,
        "asset_processing_time": 0,
        "stages": []
    }
    
    if not os.path.exists(performance_file):
        print(f"Warning: Performance file {performance_file} not found")
        return metrics
    
    try:
        with open(performance_file, 'r') as f:
            data = json.load(f)
            
        # Extract build times
        if 'buildPerformance' in data:
            for phase in data['buildPerformance']:
                metrics["stages"].append({
                    "name": phase.get('name', 'Unknown'),
                    "time_ms": phase.get('elapsedMilliseconds', 0)
                })
                
                metrics["total_build_time"] += phase.get('elapsedMilliseconds', 0)
                
                # Calculate specific metrics
                if 'compile' in phase.get('name', '').lower():
                    metrics["compile_time"] += phase.get('elapsedMilliseconds', 0)
                elif 'asset' in phase.get('name', '').lower():
                    metrics["asset_processing_time"] += phase.get('elapsedMilliseconds', 0)
    
    except Exception as e:
        print(f"Error parsing build performance data: {e}")
    
    return metrics

def generate_report(metrics, template_file, output_file):
    """
    Generate a markdown report from collected metrics
    """
    if not os.path.exists(template_file):
        print(f"Error: Template file {template_file} not found")
        return False
    
    try:
        with open(template_file, 'r') as f:
            template = f.read()
        
        # Format date
        now = datetime.datetime.now()
        template = template.replace('{{DATE}}', now.strftime('%Y-%m-%d %H:%M:%S'))
        
        # Overall status
        overall_status = " PASSED" if metrics.get('test', {}).get('total_coverage', 0) >= 80 else " ATTENTION NEEDED"
        template = template.replace('{{STATUS}}', overall_status)
        
        # Dependency status
        dep_metrics = metrics.get('dependency', {})
        outdated = dep_metrics.get('outdated_packages', 0)
        major = dep_metrics.get('major_updates', 0)
        
        if major > 0:
            dep_status = f"?? {outdated} outdated packages ({major} major updates)"
        elif outdated > 0:
            dep_status = f"? {outdated} outdated packages (minor/patch only)"
        else:
            dep_status = " All dependencies up to date"
        
        template = template.replace('{{DEPENDENCY_STATUS}}', dep_status)
        
        # Code quality status
        test_metrics = metrics.get('test', {})
        coverage = test_metrics.get('total_coverage', 0)
        
        if coverage >= 80:
            quality_status = f" {coverage}% test coverage"
        elif coverage >= 60:
            quality_status = f"? {coverage}% test coverage"
        else:
            quality_status = f" {coverage}% test coverage"
        
        template = template.replace('{{CODE_QUALITY_STATUS}}', quality_status)
        
        # Build status
        build_metrics = metrics.get('build', {})
        build_time = build_metrics.get('total_build_time', 0) / 1000  # Convert to seconds
        
        template = template.replace('{{BUILD_STATUS}}', f" Completed in {build_time:.2f}s")
        
        # Fill in other details
        template = template.replace('{{TEST_COVERAGE}}', str(coverage))
        template = template.replace('{{CODE_SIZE}}', "N/A")  # Would need code to calculate this
        template = template.replace('{{ISSUE_COUNT}}', "0")  # Would need code to calculate this
        
        # Dependency details
        dep_details = ""
        if 'packages' in dep_metrics and dep_metrics['packages']:
            dep_details = "| Package | Current | Latest |\n|---------|---------|--------|\n"
            for pkg in dep_metrics['packages'][:10]:  # Show top 10
                dep_details += f"| {pkg['name']} | {pkg['current']} | {pkg['latest']} |\n"
            
            if len(dep_metrics['packages']) > 10:
                dep_details += f"\n*...and {len(dep_metrics['packages']) - 10} more packages need updates*"
        else:
            dep_details = "No outdated dependencies found."
            
        template = template.replace('{{DEPENDENCY_DETAILS}}', dep_details)
        
        # Performance metrics
        template = template.replace('{{BUILD_TIME}}', f"{build_time:.2f}s")
        template = template.replace('{{STARTUP_TIME}}', "N/A")  # Would need code to calculate this
        template = template.replace('{{MEMORY_USAGE}}', "N/A")  # Would need code to calculate this
        
        # Empty sections
        template = template.replace('{{TOP_ISSUES}}', "No major issues found.")
        template = template.replace('{{ACTION_ITEMS}}', "- Review test coverage\n- Update dependencies")
        template = template.replace('{{NOTES}}', "This report was automatically generated.")
        
        # Write output file
        with open(output_file, 'w') as f:
            f.write(template)
            
        print(f"Report generated: {output_file}")
        return True
        
    except Exception as e:
        print(f"Error generating report: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(description='Collect and process CI/CD metrics')
    parser.add_argument('--coverage', help='Path to coverage JSON file')
    parser.add_argument('--dependencies', help='Path to dependency report file')
    parser.add_argument('--performance', help='Path to build performance file')
    parser.add_argument('--template', help='Path to report template file')
    parser.add_argument('--output', help='Path to output report file')
    
    args = parser.parse_args()
    
    metrics = {
        'test': {},
        'dependency': {},
        'build': {}
    }
    
    # Collect metrics
    if args.coverage:
        metrics['test'] = collect_test_metrics(args.coverage)
    
    if args.dependencies:
        metrics['dependency'] = collect_dependency_metrics(args.dependencies)
    
    if args.performance:
        metrics['build'] = collect_build_metrics(args.performance)
    
    # Generate report
    if args.template and args.output:
        generate_report(metrics, args.template, args.output)
    
    # Save metrics to JSON
    metrics_dir = os.path.dirname(args.output) if args.output else '.'
    metrics_file = os.path.join(metrics_dir, 'metrics.json')
    
    try:
        with open(metrics_file, 'w') as f:
            json.dump({
                'timestamp': datetime.datetime.now().isoformat(),
                'metrics': metrics
            }, f, indent=2)
        print(f"Metrics saved to {metrics_file}")
    except Exception as e:
        print(f"Error saving metrics: {e}")

if __name__ == "__main__":
    main()
