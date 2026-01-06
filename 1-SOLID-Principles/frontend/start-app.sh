#!/bin/bash

# Script to launch the React reference application for SOLID Principles course
# This script will navigate to the React app directory, install dependencies if needed,
# and start the development server.

set -e  # Exit on error

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REACT_APP_DIR="${SCRIPT_DIR}/reference-application/React"

echo "🚀 Starting React SOLID Principles Reference Application..."
echo ""

# Check if React app directory exists
if [ ! -d "$REACT_APP_DIR" ]; then
    echo "❌ Error: React app directory not found at: $REACT_APP_DIR"
    exit 1
fi

# Navigate to React app directory
cd "$REACT_APP_DIR"

# Check if node_modules exists, if not install dependencies
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies (this may take a minute)..."
    npm install
    echo ""
fi

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "❌ Error: npm is not installed. Please install Node.js and npm first."
    exit 1
fi

echo "✅ Starting development server..."
echo "📝 The app will open at http://localhost:5173 (or the next available port)"
echo "🛑 Press Ctrl+C to stop the server"
echo ""

# Start the development server
npm run dev

