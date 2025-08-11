#!/bin/bash
set -Eeuo pipefail
IFS=$'\n\t'

echo "🧪 Testing Vite Template Package (npm pack method)"
echo "=================================================="

repo_root=$(cd "$(dirname "$0")" && pwd)
workdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'tmpl-eject-vibe')
tarball=""

cleanup() {
  local ec=$?
  if [[ -n "$tarball" && -f "$repo_root/$tarball" ]]; then rm -f "$repo_root/$tarball"; fi
  rm -rf "$workdir"
  exit $ec
}
trap cleanup EXIT INT TERM

echo "📦 Creating npm package..."
pushd "$workdir" >/dev/null
tarball=$(npm pack "$repo_root" --silent | tail -n1)
echo "✅ Created: $tarball"

echo ""
echo "📂 Extracting package contents..."
tar -xzf "$tarball"
cd package

echo ""
echo "🔍 Verifying file structure..."
[[ -d template ]] || { echo "❌ ERROR: template/ directory missing"; exit 1; }
[[ -f template/_package.json ]] || { echo "❌ ERROR: template/_package.json missing"; exit 1; }
[[ -f template/src/App.tsx ]] || { echo "❌ ERROR: template/src/App.tsx missing"; exit 1; }
[[ -f template/index.html ]] || { echo "❌ ERROR: template/index.html missing"; exit 1; }
echo "✅ All required files present"

echo ""
echo "🔧 Setting up template for testing..."
cd template
cp _package.json package.json

echo ""
echo "📋 Installing dependencies..."
npm install --no-audit --no-fund --loglevel=warn

echo ""
echo "🧪 Running unit tests (template)..."
npm test --silent

echo ""
echo "🏗️ Testing TypeScript compilation..."
npx tsc --noEmit

echo ""
echo "🏗️ Testing build process..."
npm run build
[[ -f dist/index.html ]] || { echo "❌ ERROR: Build did not generate dist/index.html"; exit 1; }
echo "✅ Build successful - generated dist/index.html"

echo ""
echo "🎨 Testing copy/paste eject workflow..."
cat > src/App.tsx << 'EOF'
export default function App() {
  return (
    <div className="min-h-dvh grid place-items-center bg-gradient-to-br from-blue-50 to-indigo-100 text-gray-900">
      <main className="p-8 max-w-2xl text-center space-y-6 bg-white/80 backdrop-blur-sm rounded-2xl shadow-lg">
        <h1 className="text-3xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent">
          Template Test Success!
        </h1>
        <p className="text-lg text-gray-700">
          This confirms the copy/paste eject workflow works.
        </p>
        <div className="text-sm text-gray-500 space-y-1">
          <p>Tailwind CSS v4 classes applied</p>
          <p>TypeScript compilation working</p>
          <p>Build process successful</p>
        </div>
      </main>
    </div>
  );
}
EOF

echo ""
echo "🏗️ Rebuilding with ejected content..."
npm run build
[[ -f dist/index.html ]] || { echo "❌ ERROR: Rebuild with ejected content failed"; exit 1; }
echo "✅ Eject workflow successful"

echo ""
echo "🎉 ALL TESTS PASSED!"
echo "✅ Template package structure is valid"
echo "✅ TypeScript compilation works"
echo "✅ Build process works"
echo "✅ Copy/paste eject workflow works"
