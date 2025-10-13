#!/bin/bash

# Master CI Build and Test Script
# This script runs build and test processes for all platforms (C#, Java, Python, TypeScript)

set -e  # Exit on any error

echo "🚀 Starting Master CI Build and Test Process for All Platforms..."
echo "=================================================================="

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to run platform tests
run_platform_tests() {
    local platform=$1
    local platform_dir=$2
    
    echo ""
    echo "🔄 Running $platform Tests..."
    echo "================================"
    
    if [ -f "$platform_dir/build-and-test.sh" ]; then
        cd "$platform_dir"
        ./build-and-test.sh
        echo "✅ $platform tests completed successfully!"
    else
        echo "❌ Error: build-and-test.sh not found in $platform_dir"
        return 1
    fi
}

# Check PostgreSQL database connectivity
echo "🐘 Checking PostgreSQL database connectivity..."

# Check if docker-compose.yml exists
if [ ! -f "$SCRIPT_DIR/docker-compose.yml" ]; then
    echo "❌ Error: docker-compose.yml not found in $SCRIPT_DIR"
    echo "   Please ensure you're running this script from the correct location."
    exit 1
fi

# Check if Docker is running
echo "🐳 Checking Docker status..."
if ! docker info &> /dev/null; then
    echo "❌ Error: Docker is not running. Please start Docker and try again."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi
echo "✅ Docker is running"

# Check if PostgreSQL container is running
if ! docker ps --format "table {{.Names}}" | grep -q "ecom-postgres"; then
    echo "⚠️  PostgreSQL container is not running. Starting database..."
    cd "$SCRIPT_DIR"
    docker-compose up -d postgres
    echo "⏳ Waiting for PostgreSQL to be ready..."
    sleep 10
else
    echo "✅ PostgreSQL container is already running"
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

# Run tests for each platform
run_platform_tests "C#" "$SCRIPT_DIR/Dotnet"
run_platform_tests "Java" "$SCRIPT_DIR/Java"
run_platform_tests "Python" "$SCRIPT_DIR/Python"
run_platform_tests "TypeScript" "$SCRIPT_DIR/TypeScript"

echo ""
echo "🎉 All Platform Tests Completed Successfully!"
echo "=============================================="
echo ""
echo "📊 Summary:"
echo "   ✅ C# tests passed"
echo "   ✅ Java tests passed"
echo "   ✅ Python tests passed"
echo "   ✅ TypeScript tests passed"
echo ""
echo "🎯 Database Status:"
echo "   - PostgreSQL is running on localhost:5432"
echo "   - Database: bounteous_ecom"
echo "   - All tests include automatic database cleanup"
echo ""
echo "💡 Individual Platform Scripts:"
echo "   - C#:        ./Dotnet/build-and-test.sh"
echo "   - Java:      ./Java/build-and-test.sh"
echo "   - Python:    ./Python/build-and-test.sh"
echo "   - TypeScript: ./TypeScript/build-and-test.sh"
echo ""
echo "🔧 To stop the database:"
echo "   docker-compose down"
