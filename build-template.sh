#!/bin/bash
set -Eeuo pipefail
IFS=$'\n\t'

echo "🏗️  Building Vite Template Package"
echo "=================================="

root_dir=$(pwd)

# Clean slate to avoid stale files
rm -rf "$root_dir/template"

echo "📂 Creating template directory structure..."
mkdir -p "$root_dir/template/src" "$root_dir/template/public"

required=("index.html" "src")
for path in "${required[@]}"; do
  if [[ ! -e "$root_dir/$path" ]]; then
    echo "❌ ERROR: Required source-of-truth '$path' not found at repo root."
    echo "   Expected app sources under ./src and index.html at ./index.html."
    exit 1
  fi
done

echo "📦 Copying app sources (single source of truth → template/)..."
cp -R "$root_dir/src" "$root_dir/template/"
if [[ -d "$root_dir/public" ]]; then
  # copy contents of public if it exists (null-safe)
  cp -R "$root_dir/public/." "$root_dir/template/public/" || true
fi
cp "$root_dir/index.html" "$root_dir/template/index.html"

echo "⚙️  Copying configuration files (null-safe)..."
shopt -s nullglob
for f in tsconfig*.json vite.config.* *.config.* tailwind.config.*; do
  [[ -e "$f" ]] && cp "$f" "$root_dir/template/"
done
shopt -u nullglob

echo "🧾 Generating template _package.json..."
node - <<'NODE'
import { readFileSync, writeFileSync } from 'node:fs'
const rootPkg = JSON.parse(readFileSync('package.json', 'utf8'))

// Versions aligned with current stable releases; caret ranges to reduce install friction
const versions = {
  react: '^19.1.1',
  reactDom: '^19.1.1',
  typescript: '^5.9.0',
  vite: '^7.1.0',
  viteReact: '^5.0.0',
  tailwind: '^4.1.11',
  tailwindPostcss: '^4.1.11',
  postcss: '^8.5.6',
  autoprefixer: '^10.4.21',
  prettier: '^3.6.0',
  typesReact: '^19.0.0',
  typesReactDom: '^19.0.0'
}

const templatePkg = {
  name: 'eject-vibe',
  private: true,
  version: '0.0.0',
  type: 'module',
  scripts: {
    dev: 'vite',
    build: 'tsc -b && vite build',
    preview: 'vite preview',
    format: 'prettier --check .'
  },
  dependencies: {
    react: versions.react,
    'react-dom': versions.reactDom
  },
  devDependencies: {
    '@types/react': versions.typesReact,
    '@types/react-dom': versions.typesReactDom,
    '@vitejs/plugin-react': versions.viteReact,
    tailwindcss: versions.tailwind,
    '@tailwindcss/postcss': versions.tailwindPostcss,
    postcss: versions.postcss,
    autoprefixer: versions.autoprefixer,
    typescript: versions.typescript,
    vite: versions.vite,
    prettier: versions.prettier
  },
  engines: rootPkg.engines
}

writeFileSync('template/_package.json', JSON.stringify(templatePkg, null, 2) + '\n')
NODE

echo "🧹 Writing template/.prettierignore..."
cat > "$root_dir/template/.prettierignore" << 'IGN'
node_modules
dist
package-lock.json
IGN

echo "✅ Template build complete!"
echo ""
echo "📊 Template structure:"
find template -name "node_modules" -prune -o -type f -print | sort
