#!/bin/bash
set -e

echo "🧪 Testing Vite Template Package (npm pack method)"
echo "=================================================="

# Clean up any previous test files
rm -rf test-output/
rm -f create-vite-eject-vibe-*.tgz

# Create test directory
mkdir -p test-output
cd test-output

echo "📦 Creating npm package..."
npm pack ..
PACKAGE_FILE=$(ls create-vite-eject-vibe-*.tgz)
echo "✅ Created: $PACKAGE_FILE"

echo ""
echo "📂 Extracting package contents..."
tar -xzf $PACKAGE_FILE
cd package

echo ""
echo "🔍 Verifying file structure..."
if [[ ! -d "template" ]]; then
    echo "❌ ERROR: template/ directory missing"
    exit 1
fi

if [[ ! -f "template/_package.json" ]]; then
    echo "❌ ERROR: template/_package.json missing"
    exit 1
fi

if [[ ! -f "template/src/App.tsx" ]]; then
    echo "❌ ERROR: template/src/App.tsx missing"
    exit 1
fi

if [[ ! -f "template/index.html" ]]; then
    echo "❌ ERROR: template/index.html missing"
    exit 1
fi

echo "✅ All required files present"

echo ""
echo "🔧 Setting up template for testing..."
cd template
cp _package.json package.json

echo ""
echo "📋 Installing dependencies..."
npm install

echo ""
echo "🏗️ Testing TypeScript compilation..."
npx tsc --noEmit

echo ""
echo "🏗️ Testing build process..."
npm run build

if [[ ! -f "dist/index.html" ]]; then
    echo "❌ ERROR: Build did not generate dist/index.html"
    exit 1
fi

echo "✅ Build successful - generated dist/index.html"

echo ""
echo "🎨 Testing copy/paste eject workflow..."
cat > src/App.tsx << 'EOF'
export default function App() {
  return (
    <div className="min-h-dvh grid place-items-center bg-gradient-to-br from-blue-50 to-indigo-100 text-gray-900">
      <main className="p-8 max-w-2xl text-center space-y-6 bg-white/80 backdrop-blur-sm rounded-2xl shadow-lg">
        <h1 className="text-3xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent">
          🎉 Template Test Success!
        </h1>
        <p className="text-lg text-gray-700">
          This confirms the copy/paste eject workflow works perfectly.
        </p>
        <div className="text-sm text-gray-500 space-y-1">
          <p>✅ Tailwind CSS v4 classes applied</p>
          <p>✅ TypeScript compilation working</p>
          <p>✅ Build process successful</p>
          <p>✅ All template files in place</p>
        </div>
      </main>
    </div>
  );
}
EOF

echo ""
echo "🏗️ Rebuilding with ejected content..."
npm run build

if [[ ! -f "dist/index.html" ]]; then
    echo "❌ ERROR: Rebuild with ejected content failed"
    exit 1
fi

echo "✅ Eject workflow successful"

echo ""
echo "🧹 Cleaning up..."
cd ../../../
rm -rf test-output/
rm -f create-vite-eject-vibe-*.tgz

echo ""
echo "🎉 ALL TESTS PASSED!"
echo "✅ Template package structure is valid"
echo "✅ TypeScript compilation works"
echo "✅ Build process works"
echo "✅ Copy/paste eject workflow works"
echo ""
echo "📋 Ready for:"
echo "  • Publishing to npm"
echo "  • GitHub repo creation"
echo "  • Official Vite template usage"