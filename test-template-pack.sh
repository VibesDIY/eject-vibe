#!/bin/bash
set -e

echo "🧪 Testing Vite template with npm pack method..."

# Clean up any previous test
echo "🧹 Cleaning up previous test..."
rm -rf test-output
rm -f create-vite-eject-vibe-*.tgz

# Create npm package
echo "📦 Creating npm package..."
npm pack

# Get the generated tarball name
TARBALL=$(ls create-vite-eject-vibe-*.tgz)
echo "📦 Generated package: $TARBALL"

# Create test directory
mkdir test-output
cd test-output

# Test manual template copy approach
echo "🔄 Testing manual template approach..."
mkdir test-app
cd test-app

# Extract and copy template files
echo "📁 Copying template files..."
tar -xf ../../$TARBALL
cp -r package/template/* .
rm -rf package

# Rename template files
mv _package.json package.json
mv _package-lock.json package-lock.json

echo "📁 Validating file structure..."
[ -f package.json ] || { echo "❌ package.json missing"; exit 1; }
[ -f src/App.tsx ] || { echo "❌ src/App.tsx missing"; exit 1; }
[ -f src/App.example.jsx ] || { echo "❌ src/App.example.jsx missing"; exit 1; }
[ -f src/main.tsx ] || { echo "❌ src/main.tsx missing"; exit 1; }
[ -f index.html ] || { echo "❌ index.html missing"; exit 1; }
[ -f tailwind.config.ts ] || { echo "❌ tailwind.config.ts missing"; exit 1; }
[ -f vite.config.ts ] || { echo "❌ vite.config.ts missing"; exit 1; }
[ -d src/assets ] || { echo "❌ src/assets directory missing"; exit 1; }
[ -d public ] || { echo "❌ public directory missing"; exit 1; }
echo "✅ File structure validation passed"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Test TypeScript compilation
echo "🔍 Testing TypeScript compilation..."
npx tsc --noEmit
echo "✅ TypeScript compilation passed"

# Test build
echo "🏗️ Testing build process..."
npm run build
[ -f dist/index.html ] || { echo "❌ dist/index.html not generated"; exit 1; }
[ -d dist/assets ] || { echo "❌ dist/assets not generated"; exit 1; }
echo "✅ Build process passed"

# Test copy/paste eject flow
echo "🔄 Testing copy/paste eject flow..."
cp src/App.example.jsx src/App.tsx
npm run build
echo "✅ Copy/paste flow passed"

# Validate package.json content
echo "📝 Validating package.json content..."
node -e "
const pkg = require('./package.json');
if (pkg.name !== 'eject-vibe') throw new Error('Wrong package name: ' + pkg.name);
if (!pkg.scripts.dev) throw new Error('Missing dev script');
if (!pkg.scripts.build) throw new Error('Missing build script');
if (!pkg.dependencies.react) throw new Error('Missing react dependency');
if (!pkg.devDependencies.vite) throw new Error('Missing vite devDependency');
if (!pkg.devDependencies.tailwindcss) throw new Error('Missing tailwindcss devDependency');
console.log('✅ Package.json validation passed');
"

cd ../..

echo "🎉 All template tests passed successfully!"
echo ""
echo "📊 Test Summary:"
echo "  ✅ File structure validation"
echo "  ✅ TypeScript compilation"
echo "  ✅ Build process"
echo "  ✅ Copy/paste eject flow"
echo "  ✅ Package.json validation"
echo ""
echo "🚀 Template is ready for npm publishing!"

# Clean up
rm -f $TARBALL