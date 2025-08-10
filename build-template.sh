#!/bin/bash
set -e

echo "🏗️  Building Vite Template Package"
echo "=================================="

echo "📂 Creating template directory structure..."
mkdir -p template/src template/public

echo "📋 Source files already in template/ - preserving them..."
# Source files (src/, public/, index.html) are already in template/
# Just ensure directory exists
if [[ ! -d "template/src" ]]; then
  echo "❌ ERROR: template/src not found"
  exit 1
fi

echo "⚙️  Copying configuration files..."
cp tsconfig*.json template/
cp *.config.* template/
cp vite.config.ts template/

echo "📦 Creating template package.json..."
# Transform root package.json into template _package.json
node -e "
const pkg = JSON.parse(require('fs').readFileSync('package.json', 'utf8'));
const templatePkg = {
  name: 'eject-vibe',
  private: true,
  version: '0.0.0',
  type: 'module',
  scripts: {
    dev: 'vite',
    build: 'tsc -b && vite build',
    format: 'prettier --write .',
    preview: 'vite preview'
  },
  dependencies: {
    'react': '^19.1.1',
    'react-dom': '^19.1.1'
  },
  devDependencies: {
    '@tailwindcss/postcss': '^4.1.11',
    '@types/react': '^19.1.9',
    '@types/react-dom': '^19.1.7',
    '@vitejs/plugin-react': '^4.7.0',
    'autoprefixer': '^10.4.21',
    'postcss': '^8.5.6',
    'prettier': '^3.6.2',
    'tailwindcss': '^4.0.0',
    'typescript': '~5.8.3',
    'vite': '^7.1.0'
  },
  engines: pkg.engines
};
require('fs').writeFileSync('template/_package.json', JSON.stringify(templatePkg, null, 2) + '\n');
"

echo "🏭 Creating empty dist directory..."
mkdir -p template/dist
touch template/dist/.gitkeep

echo "✅ Template build complete!"
echo ""
echo "📊 Template structure:"
find template -name "node_modules" -prune -o -type f -print | sort