/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      typography: {
        DEFAULT: {
          css: {
            maxWidth: 'none',
            color: '#374151',
            h1: {
              color: '#111827',
              fontWeight: '700',
              fontSize: '2.25rem',
              marginBottom: '1rem',
              marginTop: '0',
            },
            h2: {
              color: '#111827',
              fontWeight: '600',
              fontSize: '1.875rem',
              marginBottom: '0.75rem',
              marginTop: '2rem',
            },
            h3: {
              color: '#111827',
              fontWeight: '600',
              fontSize: '1.5rem',
              marginBottom: '0.5rem',
              marginTop: '1.5rem',
            },
            h4: {
              color: '#111827',
              fontWeight: '600',
              fontSize: '1.25rem',
              marginBottom: '0.5rem',
              marginTop: '1.25rem',
            },
            code: {
              backgroundColor: '#f3f4f6',
              padding: '0.25rem 0.375rem',
              borderRadius: '0.25rem',
              fontSize: '0.875rem',
              fontWeight: '500',
              color: '#dc2626',
            },
            'code::before': {
              content: '""',
            },
            'code::after': {
              content: '""',
            },
            pre: {
              backgroundColor: '#1f2937',
              color: '#f9fafb',
              padding: '1rem',
              borderRadius: '0.5rem',
              overflow: 'auto',
              marginBottom: '1rem',
            },
            'pre code': {
              backgroundColor: 'transparent',
              padding: '0',
              color: 'inherit',
            },
            blockquote: {
              borderLeft: '4px solid #e5e7eb',
              paddingLeft: '1rem',
              fontStyle: 'italic',
              color: '#6b7280',
              marginLeft: '0',
              marginRight: '0',
            },
            a: {
              color: '#2563eb',
              textDecoration: 'underline',
              fontWeight: '500',
            },
            'a:hover': {
              color: '#1d4ed8',
            },
            ul: {
              marginBottom: '1rem',
            },
            ol: {
              marginBottom: '1rem',
            },
            li: {
              marginBottom: '0.25rem',
            },
            table: {
              width: '100%',
              borderCollapse: 'collapse',
              marginBottom: '1rem',
            },
            th: {
              backgroundColor: '#f9fafb',
              padding: '0.75rem',
              textAlign: 'left',
              fontWeight: '600',
              borderBottom: '1px solid #e5e7eb',
            },
            td: {
              padding: '0.75rem',
              borderBottom: '1px solid #e5e7eb',
            },
            hr: {
              borderColor: '#e5e7eb',
              marginTop: '2rem',
              marginBottom: '2rem',
            },
          },
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}
