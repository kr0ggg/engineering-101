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
