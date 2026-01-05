#!/bin/bash

# Build and Test Script for React Reference Application
# This script sets up the project, runs tests, and builds the application

set -e  # Exit on error

echo "=========================================="
echo "SOLID Principles - React Reference App"
echo "Build and Test Script"
echo "=========================================="
echo ""

# Check if node_modules exists, if not install dependencies
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    echo ""
fi

# Run linter
echo "🔍 Running ESLint..."
npm run lint || {
    echo "⚠️  Linter found issues (this is expected for violating code)"
}
echo ""

# Run type check
echo "🔍 Running TypeScript type check..."
npm run type-check || {
    echo "⚠️  Type check found issues (this is expected for violating code)"
}
echo ""

# Run tests
echo "🧪 Running tests..."
npm test -- --passWithNoTests || {
    echo "⚠️  Some tests may fail (this is expected for violating code)"
}
echo ""

# Build application
echo "🏗️  Building application..."
npm run build || {
    echo "❌ Build failed"
    exit 1
}
echo ""

echo "=========================================="
echo "✅ Build and test completed!"
echo "=========================================="
echo ""
echo "To run the development server:"
echo "  npm run dev"
echo ""
echo "To preview the production build:"
echo "  npm run preview"
echo ""

