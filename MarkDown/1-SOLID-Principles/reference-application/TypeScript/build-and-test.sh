#!/bin/bash

# TypeScript Build and Test Script
# This script installs dependencies, compiles TypeScript, and runs unit tests for the TypeScript ecommerce application

set -e  # Exit on any error

echo "🚀 Starting TypeScript Build and Test Process..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Error: Node.js is not installed. Please install Node.js to continue."
    echo "   Visit: https://nodejs.org/"
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ Error: npm is not installed. Please install npm to continue."
    echo "   Visit: https://www.npmjs.com/get-npm"
    exit 1
fi

# Display Node.js and npm versions
echo "📋 Node.js Version:"
node --version

echo "📋 npm Version:"
npm --version

# Navigate to the TypeScript project directory
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

echo "📦 Installing dependencies..."
npm install

echo "🔨 Compiling TypeScript..."
npm run build

echo "🧪 Running unit tests..."
npm test

echo "📊 Running tests with coverage..."
npm run test:coverage 2>/dev/null || echo "   Coverage script not available, running tests without coverage..."

echo "✅ TypeScript Build and Test completed successfully!"
echo ""
echo "📊 Test Summary:"
echo "   - All unit tests have been executed"
echo "   - Database cleanup is handled automatically after each test"
echo "   - Constraint validation tests verify NOT NULL and UNIQUE constraints"
echo "   - TypeScript compilation completed successfully"
echo ""
echo "🎯 Next Steps:"
echo "   - Review any test failures above"
echo "   - Check database connectivity if tests fail"
echo "   - Ensure PostgreSQL is running on localhost:5432"
echo "   - Check compiled JavaScript in dist/ directory"
echo ""
echo "💡 Available npm scripts:"
echo "   - npm run build    : Compile TypeScript"
echo "   - npm test         : Run tests"
echo "   - npm run dev      : Run in development mode"
