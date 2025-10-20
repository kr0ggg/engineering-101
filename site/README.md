## Engineering 101 Site

This Next.js app renders the repository's Markdown content as a documentation website.

### Prerequisites
- Node.js 18+

### Install
```bash
npm install
```

### Develop
```bash
npm run dev
```
Then open http://localhost:3000

### Build
```bash
npm run build && npm start
```

### How it works
- Uses Contentlayer to load all `.md` files under `courses/` and `content/` folders within the `site/` directory.
- Each file becomes a page under `/docs/<path>`.
- Home page links to the main sections.

### Notes
- Add frontmatter `title:` in Markdown to set page title (optional).
- Sidebar is generated from file paths and will reflect your folder structure.

### Add your own content
- Create folders `site/courses/` and/or `site/content/` for your Markdown files.
- Drop your `.md` files anywhere under these folders (subfolders allowed).
- Examples:
  - `site/courses/intro/lesson-1.md` → `/docs/courses/intro/lesson-1`
  - `site/content/katas/strings.md` → `/docs/content/katas/strings`


