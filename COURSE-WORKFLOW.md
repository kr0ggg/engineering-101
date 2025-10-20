# Course Material Workflow

## Quick Start

1. **Add your course content** to the `markdown/` folder
2. **Deploy** with: `./deploy-course.sh`
3. **View** at http://localhost:3000 (if using `--dev` or `--start`)

## Usage

```bash
# Basic deployment (builds the site)
./deploy-course.sh

# Deploy and start development server
./deploy-course.sh --dev

# Deploy and start production server  
./deploy-course.sh --start
```

## Workflow

1. **Edit content**: Update `.md` files in `markdown/` folder
2. **Deploy**: Run `./deploy-course.sh` 
3. **Review**: Content automatically appears in the Next.js site

## Folder Structure

```
markdown/           # Your source content (edit here)
├── intro/
│   ├── lesson-1.md
│   └── lesson-2.md
└── advanced/
    └── patterns.md

site/courses/       # Auto-populated by deploy script
├── intro/
│   ├── lesson-1.md
│   └── lesson-2.md
└── advanced/
    └── patterns.md
```

## What the script does

1. ✅ Validates `markdown/` folder exists
2. 🧹 Cleans `site/courses/` 
3. 📁 Copies all content from `markdown/` to `site/courses/`
4. 📦 Installs dependencies (if needed)
5. 🔨 Builds the Next.js site
6. 🌐 Optionally starts the server

## Tips

- Keep your source content in `markdown/` - this is your "source of truth"
- The script preserves folder structure when copying
- Add `title:` frontmatter to `.md` files for better page titles
- Use `--dev` for development with hot reloading
- Use `--start` for production serving
