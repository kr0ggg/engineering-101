#!/bin/bash

# Deploy Course Script
# Copies markdown content to site/courses and builds/deploys the Next.js app

set -e  # Exit on any error

echo "🚀 Starting course deployment..."

# Check if markdown folder exists
if [ ! -d "markdown" ]; then
    echo "❌ Error: markdown/ folder not found"
    echo "   Create a markdown/ folder and add your .md files there"
    exit 1
fi

# Check if site folder exists
if [ ! -d "site" ]; then
    echo "❌ Error: site/ folder not found"
    echo "   Make sure you're running this from the repo root"
    exit 1
fi

# Clean and copy markdown content
echo "📁 Copying markdown content to site/courses..."
rm -rf site/courses/*
find markdown -name "*.md" -type f -not -path "*/node_modules/*" -not -path "*/target/*" -not -path "*/dist/*" -not -path "*/build/*" -not -path "*/venv/*" -not -path "*/.git/*" -not -name "10-customer-service-tests.md" -not -name "01-customer-entity.md" | while read file; do
    # Get relative path from markdown directory
    rel_path=${file#markdown/}
    # Create target directory
    target_dir="site/courses/$(dirname "$rel_path")"
    mkdir -p "$target_dir"
    # Copy the file
    cp "$file" "site/courses/$rel_path"
done

echo "✅ Content copied successfully"

# Navigate to site directory
cd site

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Build the site
echo "🔨 Building Next.js site..."
npm run build

echo "✅ Build completed successfully!"

# Check if we should start the server
if [ "$1" = "--start" ]; then
    echo "🌐 Starting production server on port 3001..."
    PORT=3001 npm start
elif [ "$1" = "--dev" ]; then
    echo "🛠️  Starting development server on port 3001..."
    PORT=3001 npm run dev
else
    echo "🎉 Deployment complete!"
    echo ""
    echo "Next steps:"
    echo "  • Run './deploy-course.sh --dev' to start development server on port 3001"
    echo "  • Run './deploy-course.sh --start' to start production server on port 3001"
    echo "  • Or manually run 'cd site && PORT=3001 npm start' to serve the built app"
fi
