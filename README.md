# eject-vibe

**Vite + React + Tailwind v4 template to host a Vibe's App.jsx.**

A minimal, modern template for quickly deploying your generated Vibe components as standalone React applications.

> **Note**  
> This repository stores the *template builder*. When you click “Use this template”, GitHub generates a new project that contains only the files inside the `template/` directory. The root-level scripts (`build-template`, `test-template-pack`, etc.) are for contributors maintaining the template itself.

## 🚀 Quickstart

### CLI (Preferred)
```bash
npm create vite@latest my-app -- --template vibes-diy/eject-vibe
cd my-app
npm install
npm run dev
```

### CLI (Fallback)
If the above doesn't work:
```bash
npx degit vibes-diy/eject-vibe my-app
cd my-app
npm install
npm run dev
```

### Web-based Usage
- **[Use this template](https://github.com/VibesDIY/eject-vibe/generate)** - Create a new repo from this template
- **[Open in StackBlitz](https://stackblitz.com/github/vibes-diy/eject-vibe)** - Edit online instantly
- **[Deploy to Netlify](https://app.netlify.com/start/deploy?repository=https://github.com/VibesDIY/eject-vibe)** - One-click deployment

[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/VibesDIY/eject-vibe)

## 📋 Initial Eject via Copy/Paste

Once you have the template running:

1. Replace the contents of `src/App.tsx` with your generated App.jsx code
2. Optionally rename the file to `src/App.jsx` if you prefer pure JSX
3. The hot reload will automatically update your app

**Example App.jsx to paste:**
```jsx
export default function App() {
  return (
    <div className="min-h-dvh grid place-items-center bg-white text-gray-900">
      <main className="p-6 max-w-xl text-center space-y-3">
        <h1 className="text-2xl font-semibold">Your Vibe goes here</h1>
        <p className="text-sm opacity-80">
          Replace the component body in src/App.tsx with your generated App.jsx.
        </p>
      </main>
    </div>
  );
}
```

## 🛠 Development

**Requirements:** Node.js 20.19+ or 22.12+

**Available scripts:**
- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run format` - Format code with Prettier

**Package managers:** This template works with npm, pnpm, or bun.

## 🏗 What's Included

- **Vite** - Fast build tool and dev server
- **React 19** - Latest React with TypeScript support
- **Tailwind CSS v4** - Modern utility-first CSS framework
- **PostCSS** - CSS processing with autoprefixer
- **Prettier** - Code formatting
- **TypeScript** - Type safety (optional - you can use .jsx files)

## 🔧 Troubleshooting

**CSS not loading?** Make sure Tailwind classes are working by checking if the placeholder text is styled.

**TypeScript errors?** You can rename `App.tsx` to `App.jsx` and remove TypeScript entirely if needed.

**Build failing?** Ensure all dependencies are installed with `npm install` and your Node.js version is 20.19+ or 22.12+.

**Vite template not found?** Use the degit fallback method shown above.

---

Built for the [Vibes.diy](https://vibes.diy) ecosystem. Generate beautiful components and deploy them instantly.
