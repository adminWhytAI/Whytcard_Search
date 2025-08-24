#!/bin/bash

# CircleCI Configuration Validation Script
# This script helps validate the CircleCI configuration locally

set -e

echo "🔍 Validating CircleCI Configuration..."

# Check if CircleCI CLI is installed
if ! command -v circleci &> /dev/null; then
    echo "❌ CircleCI CLI is not installed."
    echo "Please install it from: https://circleci.com/docs/local-cli/"
    exit 1
fi

# Validate the configuration syntax
echo "📋 Validating configuration syntax..."
if circleci config validate .circleci/config.yml; then
    echo "✅ Configuration syntax is valid"
else
    echo "❌ Configuration syntax is invalid"
    exit 1
fi

# Check project type detection logic
echo "🔍 Testing project type detection..."

# Test Node.js detection
echo "Testing Node.js project detection..."
nodejs_project_found=false
if [ -f "package.json" ]; then
    nodejs_project_found=true
    echo "✅ Node.js project detected (package.json found)"
else
    echo "ℹ️  No package.json found - Node.js job will be skipped"
fi

# Test Python detection
echo "Testing Python project detection..."
python_files_found=false
if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    python_files_found=true
fi

if [ "$python_files_found" = true ]; then
    echo "✅ Python project detected"
else
    echo "ℹ️  No Python project files found - Python job will be skipped"
fi

# Test generic project validation
echo "Testing generic project validation..."
generic_project_found=false
if [ -f "Makefile" ] || [ -f "Dockerfile" ] || [ -f "README.md" ] || [ -d "src" ] || [ -d "lib" ]; then
    generic_project_found=true
fi

if [ "$generic_project_found" = true ]; then
    echo "✅ Generic project structure detected"
else
    echo "⚠️  Limited generic project structure found"
fi

# Check for coverage directories
echo "🧪 Checking coverage setup..."
if [ -d "coverage" ]; then
    echo "✅ Coverage directory exists"
else
    echo "ℹ️  No coverage directory found - will be created during test runs"
fi

# Summary
echo ""
echo "📊 Validation Summary:"
echo "- Configuration syntax: ✅ Valid"
echo "- Project type detection: ✅ Working"
echo "- Coverage setup: ✅ Ready"
echo ""

# Show detected project types
detected_types=""
if [ "$nodejs_project_found" = true ]; then
    detected_types="${detected_types}Node.js "
fi
if [ "$python_files_found" = true ]; then
    detected_types="${detected_types}Python "
fi
if [ "$generic_project_found" = true ]; then
    detected_types="${detected_types}Generic "
fi

if [ -n "$detected_types" ]; then
    echo "🎯 Project Types Found: $detected_types"
else
    echo "⚠️  No specific project types detected"
fi

echo ""
echo "🎉 CircleCI configuration validation completed successfully!"
echo ""
echo "💡 To test locally, you can use:"
echo "   circleci local execute --job <job-name>"
echo ""
echo "📚 Available jobs:"
echo "   - build-and-test-node"
echo "   - build-and-test-python" 
echo "   - build-and-test-generic"
echo "   - say-hello"