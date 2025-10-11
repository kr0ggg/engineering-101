#!/bin/bash

# Python Build and Test Script
# This script sets up virtual environment, installs dependencies, and runs unit tests for the Python ecommerce application

set -e  # Exit on any error

echo "🚀 Starting Python Build and Test Process..."

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: Python 3 is not installed. Please install Python 3 to continue."
    echo "   Visit: https://www.python.org/downloads/"
    exit 1
fi

# Display Python version
echo "📋 Python Version:"
python3 --version

# Navigate to the Python project directory
cd "$(dirname "$0")"

echo "🐍 Setting up virtual environment..."
if [ -d "venv" ]; then
    echo "   Virtual environment already exists, removing old one..."
    rm -rf venv
fi

python3 -m venv venv
source venv/bin/activate

echo "📦 Installing dependencies..."
pip install --upgrade pip
pip install setuptools wheel
pip install -e .
pip install pytest

echo "🧪 Running unit tests..."
python -m pytest tests/ -v --tb=short

echo "📊 Generating test coverage report..."
pip install pytest-cov
python -m pytest tests/ --cov=src/bounteous_ecom --cov-report=html --cov-report=term

echo "✅ Python Build and Test completed successfully!"
echo ""
echo "📊 Test Summary:"
echo "   - All unit tests have been executed"
echo "   - Database cleanup is handled automatically after each test"
echo "   - Constraint validation tests verify NOT NULL and UNIQUE constraints"
echo "   - Coverage report generated in htmlcov/index.html"
echo ""
echo "🎯 Next Steps:"
echo "   - Review any test failures above"
echo "   - Check database connectivity if tests fail"
echo "   - Ensure PostgreSQL is running on localhost:5432"
echo "   - View coverage report: htmlcov/index.html"
echo ""
echo "💡 To activate the virtual environment manually:"
echo "   source venv/bin/activate"
