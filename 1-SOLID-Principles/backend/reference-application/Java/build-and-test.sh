#!/bin/bash

# Java Build and Test Script
# This script compiles and runs unit tests for the Java ecommerce application

set -e  # Exit on any error

echo "🚀 Starting Java Build and Test Process..."

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "❌ Error: Java is not installed. Please install Java JDK to continue."
    echo "   Visit: https://adoptium.net/ or https://openjdk.java.net/"
    exit 1
fi

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "❌ Error: Maven is not installed. Please install Maven to continue."
    echo "   Visit: https://maven.apache.org/install.html"
    exit 1
fi

# Display Java and Maven versions
echo "📋 Java Version:"
java -version

echo "📋 Maven Version:"
mvn --version

# Navigate to the Java project directory
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

echo "📦 Downloading dependencies..."
mvn dependency:resolve

echo "🔨 Compiling the project..."
mvn compile

echo "🧪 Running unit tests..."
mvn test

echo "📊 Generating test report..."
mvn surefire-report:report

echo "✅ Java Build and Test completed successfully!"
echo ""
echo "📊 Test Summary:"
echo "   - All unit tests have been executed"
echo "   - Database cleanup is handled automatically after each test"
echo "   - Constraint validation tests verify NOT NULL and UNIQUE constraints"
echo "   - Test report generated in target/site/surefire-report.html"
echo ""
echo "🎯 Next Steps:"
echo "   - Review any test failures above"
echo "   - Check database connectivity if tests fail"
echo "   - Ensure PostgreSQL is running on localhost:5432"
echo "   - View detailed test report: target/site/surefire-report.html"
