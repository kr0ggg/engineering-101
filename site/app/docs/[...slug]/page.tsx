import { notFound } from 'next/navigation'
import fs from 'fs'
import path from 'path'
import Link from 'next/link'
import { marked } from 'marked'

// Configure marked for better rendering
marked.setOptions({
  breaks: true,
  gfm: true,
})

function buildTree(files: string[]) {
  const root: any = {}
  for (const file of files) {
    const parts = file.split('/')
    let node = root
    for (const part of parts) {
      node[part] = node[part] || {}
      node = node[part]
    }
  }
  return root
}

function Sidebar() {
  const coursesDir = path.join(process.cwd(), 'courses')
  const files: string[] = []
  
  function scanDir(dir: string, prefix: string = '') {
    try {
      const items = fs.readdirSync(dir)
      for (const item of items) {
        const fullPath = path.join(dir, item)
        const stat = fs.statSync(fullPath)
        if (stat.isDirectory()) {
          scanDir(fullPath, prefix + item + '/')
        } else if (item.endsWith('.md')) {
          files.push(prefix + item.replace('.md', ''))
        }
      }
    } catch (error) {
      // Directory doesn't exist or can't be read
    }
  }
  
  scanDir(coursesDir)
  const tree = buildTree(files)
  
  const render = (node: any, prefix: string[] = []) => {
    return (
      <ul className="space-y-1">
        {Object.keys(node).sort().map((k) => {
          const next = node[k]
          const path = [...prefix, k]
          const href = `/docs/${path.join('/')}`
          const isLeaf = Object.keys(next).length === 0
          return (
            <li key={href}>
              <Link href={href} className="sidebar-item">
                {k}
              </Link>
              {!isLeaf && (
                <div className="ml-4 mt-1">
                  {render(next, path)}
                </div>
              )}
            </li>
          )
        })}
      </ul>
    )
  }
  
  return (
    <aside className="sidebar">
      <div className="sidebar-nav">
        <Link href="/" className="text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600">
          ← Engineering 101
        </Link>
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Course Content</h2>
        {render(tree)}
      </div>
    </aside>
  )
}

export async function generateStaticParams() {
  const coursesDir = path.join(process.cwd(), 'courses')
  const params: { slug: string[] }[] = []
  
  function scanDir(dir: string, prefix: string[] = []) {
    try {
      const items = fs.readdirSync(dir)
      for (const item of items) {
        const fullPath = path.join(dir, item)
        const stat = fs.statSync(fullPath)
        if (stat.isDirectory()) {
          scanDir(fullPath, [...prefix, item])
        } else if (item.endsWith('.md')) {
          params.push({ slug: [...prefix, item.replace('.md', '')] })
        }
      }
    } catch (error) {
      // Directory doesn't exist or can't be read
    }
  }
  
  scanDir(coursesDir)
  return params
}

export default function DocPage({ params }: { params: { slug: string[] } }) {
  const slug = params.slug.join('/')
  const filePath = path.join(process.cwd(), 'courses', slug + '.md')
  
  let content = ''
  let title = slug.split('/').pop() || 'Untitled'
  
  try {
    content = fs.readFileSync(filePath, 'utf8')
    // Extract title from frontmatter if present
    const frontmatterMatch = content.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/)
    if (frontmatterMatch) {
      const frontmatter = frontmatterMatch[1]
      const titleMatch = frontmatter.match(/^title:\s*(.+)$/m)
      if (titleMatch) {
        title = titleMatch[1].replace(/['"]/g, '')
      }
      content = frontmatterMatch[2]
    }
  } catch (error) {
    return notFound()
  }
  
  return (
    <div className="flex min-h-screen bg-gray-50">
      <Sidebar />
      <main className="main-content">
        <div className="content-wrapper">
          <div className="page-header">
            <h1 className="page-title">{title}</h1>
          </div>
          <div className="prose prose-lg max-w-none">
            <div dangerouslySetInnerHTML={{ __html: marked(content) }} />
          </div>
        </div>
      </main>
    </div>
  )
}


