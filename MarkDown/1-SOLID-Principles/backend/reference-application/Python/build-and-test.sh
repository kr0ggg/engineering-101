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

# Check PostgreSQL database connectivity
echo "🐘 Checking PostgreSQL database connectivity..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Check if docker-compose.yml exists
if [ ! -f "$ROOT_DIR/docker-compose.yml" ]; then
    echo "❌ Error: docker-compose.yml not found in $ROOT_DIR"
    echo "   Please ensure you're running this script from the correct location."
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "❌ Error: Docker is not running. Please start Docker and try again."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if PostgreSQL container is running
if ! docker ps --format "table {{.Names}}" | grep -q "ecom-postgres"; then
    echo "⚠️  PostgreSQL container is not running. Starting database..."
    cd "$ROOT_DIR"
    docker-compose up -d postgres
    echo "⏳ Waiting for PostgreSQL to be ready..."
    sleep 10
fi

# Test database connectivity
echo "🔍 Testing database connectivity..."
if ! docker exec ecom-postgres pg_isready -h localhost -p 5432 -U postgres &> /dev/null; then
    echo "❌ Error: Cannot connect to PostgreSQL database."
    echo "   Please ensure the database is running and accessible."
    echo "   Try running: docker-compose up -d postgres"
    exit 1
fi

echo "✅ PostgreSQL database is running and accessible"

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
