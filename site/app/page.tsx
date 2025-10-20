import Link from 'next/link'
import fs from 'fs'
import path from 'path'

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
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Course Content</h2>
        {render(tree)}
      </div>
    </aside>
  )
}

export default function Home() {
  return (
    <div className="flex min-h-screen bg-gray-50">
      <Sidebar />
      <main className="main-content">
        <div className="content-wrapper">
          <div className="page-header">
            <h1 className="page-title">Engineering 101</h1>
            <p className="page-subtitle">Master SOLID Principles and Domain-Driven Design</p>
          </div>
          
          <div className="grid md:grid-cols-2 gap-8">
            <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow">
              <div className="flex items-center mb-4">
                <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mr-4">
                  <svg className="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <h3 className="text-xl font-semibold text-gray-900">SOLID Principles</h3>
              </div>
              <p className="text-gray-600 mb-4">Learn the five fundamental principles of object-oriented design that make code maintainable and extensible.</p>
              <Link 
                href="/docs/1-SOLID-Principles/0-README" 
                className="inline-flex items-center text-blue-600 hover:text-blue-700 font-medium"
              >
                Start Learning
                <svg className="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                </svg>
              </Link>
            </div>
            
            <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow">
              <div className="flex items-center mb-4">
                <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mr-4">
                  <svg className="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                  </svg>
                </div>
                <h3 className="text-xl font-semibold text-gray-900">Domain-Driven Design</h3>
              </div>
              <p className="text-gray-600 mb-4">Master the art of modeling complex business domains and building software that reflects real-world concepts.</p>
              <Link 
                href="/docs/2-Domain-Driven-Design/0-README" 
                className="inline-flex items-center text-blue-600 hover:text-blue-700 font-medium"
              >
                Start Learning
                <svg className="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                </svg>
              </Link>
            </div>
          </div>
          
          <div className="mt-12 bg-blue-50 rounded-lg p-6">
            <h3 className="text-lg font-semibold text-blue-900 mb-2">Explore All Content</h3>
            <p className="text-blue-700">Use the sidebar navigation to browse through all available lessons, examples, and exercises.</p>
          </div>
        </div>
      </main>
    </div>
  )
}


