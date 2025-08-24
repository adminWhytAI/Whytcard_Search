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

# Initialize project type detection variables
node_project_found=false
python_files_found=false
generic_project_found=false

# Test Node.js detection
echo "Testing Node.js project detection..."
if [ -f "package.json" ]; then
    echo "✅ Node.js project detected (package.json found)"
    node_project_found=true
python_files_found=false
if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    python_files_found=true
fi

else
    echo "ℹ️  No package.json found - Node.js job will be skipped"
fi

# Test Python detection
echo "Testing Python project detection..."
if [ "$python_files_found" = true ]; then
    echo "✅ Python project detected"
    python_files_found=true
else
    echo "ℹ️  No Python project files found - Python job will be skipped"
fi

# Test generic project validation
echo "Testing generic project validation..."
if [ -f "Makefile" ] || [ -f "Dockerfile" ] || [ -f "README.md" ] || [ -d "src" ] || [ -d "lib" ]; then
    echo "✅ Generic project structure detected"
    generic_project_found=true
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
echo "- Project type detection:"
echo "  - Node.js: $([ "$node_project_found" = true ] && echo "✅ Detected" || echo "❌ Not found")"
echo "  - Python: $([ "$python_files_found" = true ] && echo "✅ Detected" || echo "❌ Not found")"
echo "  - Generic: $([ "$generic_project_found" = true ] && echo "✅ Detected" || echo "❌ Limited structure")"
echo "- Coverage setup: ✅ Ready"
echo ""
echo "🎯 Project Types Found: $([ "$node_project_found" = true ] && echo -n "Node.js ")$([ "$python_files_found" = true ] && echo -n "Python ")$([ "$generic_project_found" = true ] && echo -n "Generic ")"
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
