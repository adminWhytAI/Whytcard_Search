[![Codacy Badge](https://app.codacy.com/project/badge/Grade/f8df34a6e1cf4728a3eec785dff39cd6)](https://app.codacy.com?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

# Whytcard Search

A search application with improved CI/CD pipeline using CircleCI.

## CI/CD Pipeline

This project uses CircleCI for continuous integration and deployment. The configuration has been optimized to address common issues and implement best practices.

### Key Features

- **Multi-language support**: Automatic detection and handling of Node.js, Python, and generic projects
- **Improved error handling**: Proper exit codes and fail-fast approach for better reliability
- **Resource optimization**: Targeted branch filtering to reduce unnecessary builds
- **Coverage reporting**: Robust coverage report generation and upload with proper error handling
- **Project validation**: Comprehensive project type validation before job execution

### Supported Project Types

1. **Node.js Projects**: Detected by presence of `package.json`
2. **Python Projects**: Detected by presence of `requirements.txt`, `pyproject.toml`, or `setup.py`
3. **Generic Projects**: Fallback for other project types with basic validation

### Branch Strategy

CI/CD jobs run on the following branches:
- `main` / `master`
- `develop`
- `feature/*`
- `hotfix/*`

## Documentation

- [CircleCI Improvements](CIRCLECI_IMPROVEMENTS.md) - Detailed documentation of CI/CD improvements
- [Validation Script](scripts/validate-circleci.sh) - Local validation script for CircleCI configuration