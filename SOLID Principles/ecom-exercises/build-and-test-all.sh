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

# Check if Docker is running (needed for PostgreSQL)
echo "🐳 Checking Docker status..."
if ! docker info &> /dev/null; then
    echo "⚠️  Warning: Docker is not running. PostgreSQL database may not be available."
    echo "   Please start Docker and run: docker-compose up -d"
    echo ""
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Aborting. Please start Docker and try again."
        exit 1
    fi
else
    echo "✅ Docker is running"
fi

# Start PostgreSQL database
echo "🐘 Starting PostgreSQL database..."
cd "$SCRIPT_DIR"
if [ -f "docker-compose.yml" ]; then
    docker-compose up -d
    echo "✅ PostgreSQL database started"
else
    echo "⚠️  Warning: docker-compose.yml not found. Please ensure PostgreSQL is running manually."
fi

# Wait a moment for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 5

# Run tests for each platform
run_platform_tests "C#" "$SCRIPT_DIR/CSharp"
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
echo "   - C#:        ./CSharp/build-and-test.sh"
echo "   - Java:      ./Java/build-and-test.sh"
echo "   - Python:    ./Python/build-and-test.sh"
echo "   - TypeScript: ./TypeScript/build-and-test.sh"
echo ""
echo "🔧 To stop the database:"
echo "   docker-compose down"
