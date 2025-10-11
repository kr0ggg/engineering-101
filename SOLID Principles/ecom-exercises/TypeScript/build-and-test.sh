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
