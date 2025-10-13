#!/bin/bash

# C# Build and Test Script
# This script compiles and runs unit tests for the C# ecommerce application

set -e  # Exit on any error

echo "🚀 Starting C# Build and Test Process..."

# Check if dotnet is installed
if ! command -v dotnet &> /dev/null; then
    echo "❌ Error: .NET SDK is not installed. Please install .NET SDK to continue."
    echo "   Visit: https://dotnet.microsoft.com/download"
    exit 1
fi

# Display .NET version
echo "📋 .NET Version:"
dotnet --version

# Navigate to the C# project directory
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

echo "📦 Restoring NuGet packages..."
dotnet restore bounteous-ecom.sln

echo "🔨 Building the solution..."
dotnet build bounteous-ecom.sln --configuration Release --no-restore

echo "🧪 Running unit tests..."
dotnet test src/App.Tests/App.Tests.csproj --configuration Release --no-build --verbosity normal

echo "✅ C# Build and Test completed successfully!"
echo ""
echo "📊 Test Summary:"
echo "   - All unit tests have been executed"
echo "   - Database cleanup is handled automatically after each test"
echo "   - Constraint validation tests verify NOT NULL and UNIQUE constraints"
echo ""
echo "🎯 Next Steps:"
echo "   - Review any test failures above"
echo "   - Check database connectivity if tests fail"
echo "   - Ensure PostgreSQL is running on localhost:5432"
