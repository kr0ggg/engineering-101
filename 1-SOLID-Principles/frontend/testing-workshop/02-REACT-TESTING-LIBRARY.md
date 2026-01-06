# React Testing Library Comprehensive Guide

## Overview

React Testing Library (RTL) is the recommended testing library for React applications. It encourages testing components the way users interact with them, focusing on behavior rather than implementation details.

## Installation

```bash
npm install --save-dev @testing-library/react @testing-library/jest-dom @testing-library/user-event
```

## Core API

### render()

Renders a React component into a container and returns query functions.

```typescript
import { render, screen } from '@testing-library/react';

test('renders component', () => {
  const { container, getByText } = render(<MyComponent />);
  
  // Use screen queries (recommended)
  expect(screen.getByText('Hello')).toBeInTheDocument();
  
  // Or use returned queries
  expect(getByText('Hello')).toBeInTheDocument();
});
```

### screen

Global object that provides all query functions. Recommended over destructuring from render().

```typescript
import { render, screen } from '@testing-library/react';

test('using screen', () => {
  render(<MyComponent />);
  
  // All queries available on screen
  screen.getByRole('button');
  screen.getByText('Submit');
  screen.getByLabelText('Email');
});
```

## Query Methods

### Query Types

Three types of queries with different behaviors:

1. **getBy**: Returns element or throws error
2. **queryBy**: Returns element or null (doesn't throw)
3. **findBy**: Returns promise that resolves to element (async)

```typescript
// getBy - Throws if not found
const button = screen.getByRole('button'); // ✅ Element exists
const missing = screen.getByRole('missing'); // ❌ Throws error

// queryBy - Returns null if not found
const button = screen.queryByRole('button'); // ✅ Element or null
const missing = screen.queryByRole('missing'); // ✅ Returns null

// findBy - Async, waits for element
const button = await screen.findByRole('button'); // ✅ Waits up to 1000ms
```

### Query Priority

Use queries in this order (most to least preferred):

#### 1. Accessible to Everyone

```typescript
// getByRole - Best for interactive elements
screen.getByRole('button', { name: 'Submit' });
screen.getByRole('textbox', { name: 'Email' });
screen.getByRole('heading', { name: 'Welcome' });

// getByLabelText - Best for form fields
screen.getByLabelText('Email address');
screen.getByLabelText(/password/i);

// getByPlaceholderText - For inputs with placeholders
screen.getByPlaceholderText('Enter email');

// getByText - For non-interactive text
screen.getByText('Welcome to our app');
screen.getByText(/hello/i);
```

#### 2. Semantic Queries

```typescript
// getByAltText - For images
screen.getByAltText('Profile picture');

// getByTitle - For elements with title attribute
screen.getByTitle('Close dialog');
```

#### 3. Test IDs (Last Resort)

```typescript
// getByTestId - Only when nothing else works
screen.getByTestId('custom-element');

// In component:
<div data-testid="custom-element">Content</div>
```

### Query Variants

Each query has three variants:

```typescript
// Single element
screen.getByRole('button');      // Throws if 0 or >1
screen.queryByRole('button');    // Returns null if 0, throws if >1
await screen.findByRole('button'); // Async, throws if 0 or >1

// Multiple elements
screen.getAllByRole('button');      // Throws if 0
screen.queryAllByRole('button');    // Returns [] if 0
await screen.findAllByRole('button'); // Async, throws if 0
```

## Common Queries

### getByRole

Most versatile and accessible query.

```typescript
// Buttons
screen.getByRole('button', { name: 'Submit' });
screen.getByRole('button', { name: /submit/i });

// Links
screen.getByRole('link', { name: 'Home' });

// Inputs
screen.getByRole('textbox', { name: 'Email' });
screen.getByRole('checkbox', { name: 'Accept terms' });
screen.getByRole('radio', { name: 'Option 1' });

// Headings
screen.getByRole('heading', { name: 'Welcome', level: 1 });

// Lists
screen.getByRole('list');
screen.getByRole('listitem');

// Other
screen.getByRole('dialog');
screen.getByRole('alert');
screen.getByRole('status'); // For loading indicators
```

### getByLabelText

Best for form fields.

```typescript
// Explicit label
<label htmlFor="email">Email</label>
<input id="email" />

screen.getByLabelText('Email');

// Implicit label
<label>
  Email
  <input />
</label>

screen.getByLabelText('Email');

// aria-label
<input aria-label="Email address" />

screen.getByLabelText('Email address');
```

### getByText

For non-interactive text content.

```typescript
// Exact match
screen.getByText('Hello World');

// Case insensitive
screen.getByText('hello world', { exact: false });

// Regex
screen.getByText(/hello/i);

// Function matcher
screen.getByText((content, element) => {
  return element?.tagName.toLowerCase() === 'span' && content.includes('Hello');
});

// Partial match
screen.getByText('Hello', { exact: false }); // Matches "Hello World"
```

### getByPlaceholderText

For inputs with placeholder text.

```typescript
<input placeholder="Enter your email" />

screen.getByPlaceholderText('Enter your email');
screen.getByPlaceholderText(/email/i);
```

## User Interactions

### @testing-library/user-event

Simulates real user interactions (recommended over fireEvent).

```typescript
import userEvent from '@testing-library/user-event';

test('user interactions', async () => {
  const user = userEvent.setup();
  render(<MyForm />);
  
  // Type in input
  await user.type(screen.getByLabelText('Email'), 'test@example.com');
  
  // Click button
  await user.click(screen.getByRole('button', { name: 'Submit' }));
  
  // Select option
  await user.selectOptions(screen.getByRole('combobox'), 'option1');
  
  // Check checkbox
  await user.click(screen.getByRole('checkbox', { name: 'Accept' }));
  
  // Clear input
  await user.clear(screen.getByLabelText('Email'));
  
  // Tab navigation
  await user.tab();
  
  // Keyboard shortcuts
  await user.keyboard('{Enter}');
  await user.keyboard('{Escape}');
});
```

### Common User Actions

```typescript
// Typing
await user.type(input, 'Hello');
await user.type(input, 'Hello{Enter}'); // Type and press Enter

// Clicking
await user.click(button);
await user.dblClick(button);
await user.tripleClick(button);

// Hovering
await user.hover(element);
await user.unhover(element);

// Selecting
await user.selectOptions(select, 'value');
await user.selectOptions(select, ['value1', 'value2']); // Multiple

// Uploading files
const file = new File(['content'], 'test.png', { type: 'image/png' });
await user.upload(input, file);

// Keyboard
await user.keyboard('{Shift>}A{/Shift}'); // Shift+A
await user.keyboard('[ControlLeft>]a[/ControlLeft]'); // Ctrl+A
```

## Async Testing

### waitFor

Wait for assertions to pass.

```typescript
import { waitFor } from '@testing-library/react';

test('async data loading', async () => {
  render(<CustomerList />);
  
  // Wait for element to appear
  await waitFor(() => {
    expect(screen.getByText('John Doe')).toBeInTheDocument();
  });
  
  // With custom timeout
  await waitFor(
    () => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
    },
    { timeout: 3000 }
  );
});
```

### findBy Queries

Async queries that wait for elements.

```typescript
test('async with findBy', async () => {
  render(<CustomerList />);
  
  // Automatically waits up to 1000ms
  const customer = await screen.findByText('John Doe');
  expect(customer).toBeInTheDocument();
  
  // Multiple elements
  const customers = await screen.findAllByRole('listitem');
  expect(customers).toHaveLength(3);
});
```

### waitForElementToBeRemoved

Wait for element to be removed from DOM.

```typescript
import { waitForElementToBeRemoved } from '@testing-library/react';

test('loading spinner disappears', async () => {
  render(<CustomerList />);
  
  const spinner = screen.getByRole('status');
  
  await waitForElementToBeRemoved(spinner);
  
  expect(screen.getByText('John Doe')).toBeInTheDocument();
});
```

## Testing Patterns

### Form Testing

```typescript
test('form submission', async () => {
  const user = userEvent.setup();
  const onSubmit = jest.fn();
  
  render(<CustomerForm onSubmit={onSubmit} />);
  
  // Fill form
  await user.type(screen.getByLabelText('Name'), 'John Doe');
  await user.type(screen.getByLabelText('Email'), 'john@example.com');
  
  // Submit
  await user.click(screen.getByRole('button', { name: 'Submit' }));
  
  // Verify
  expect(onSubmit).toHaveBeenCalledWith({
    name: 'John Doe',
    email: 'john@example.com',
  });
});
```

### Validation Testing

```typescript
test('form validation', async () => {
  const user = userEvent.setup();
  render(<CustomerForm />);
  
  // Submit empty form
  await user.click(screen.getByRole('button', { name: 'Submit' }));
  
  // Check error messages
  expect(screen.getByText('Name is required')).toBeInTheDocument();
  expect(screen.getByText('Email is required')).toBeInTheDocument();
  
  // Fill valid data
  await user.type(screen.getByLabelText('Name'), 'John');
  
  // Error should disappear
  expect(screen.queryByText('Name is required')).not.toBeInTheDocument();
});
```

### Conditional Rendering

```typescript
test('conditional rendering', async () => {
  render(<CustomerList />);
  
  // Initially shows loading
  expect(screen.getByText('Loading...')).toBeInTheDocument();
  
  // After loading, shows customers
  expect(await screen.findByText('John Doe')).toBeInTheDocument();
  expect(screen.queryByText('Loading...')).not.toBeInTheDocument();
});
```

### List Testing

```typescript
test('renders list of items', async () => {
  render(<CustomerList />);
  
  const customers = await screen.findAllByRole('listitem');
  
  expect(customers).toHaveLength(3);
  expect(customers[0]).toHaveTextContent('John Doe');
  expect(customers[1]).toHaveTextContent('Jane Smith');
  expect(customers[2]).toHaveTextContent('Bob Johnson');
});
```

### Modal/Dialog Testing

```typescript
test('opens and closes modal', async () => {
  const user = userEvent.setup();
  render(<App />);
  
  // Modal not visible initially
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument();
  
  // Open modal
  await user.click(screen.getByRole('button', { name: 'Open Modal' }));
  
  // Modal is visible
  expect(screen.getByRole('dialog')).toBeInTheDocument();
  expect(screen.getByText('Modal Content')).toBeInTheDocument();
  
  // Close modal
  await user.click(screen.getByRole('button', { name: 'Close' }));
  
  // Modal is gone
  await waitForElementToBeRemoved(screen.queryByRole('dialog'));
});
```

## Custom Render

Create custom render function with providers.

```typescript
// test-utils.tsx
import { render, RenderOptions } from '@testing-library/react';
import { BrowserRouter } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

interface CustomRenderOptions extends RenderOptions {
  initialRoute?: string;
}

export function renderWithProviders(
  ui: React.ReactElement,
  { initialRoute = '/', ...options }: CustomRenderOptions = {}
) {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: { retry: false },
    },
  });

  window.history.pushState({}, 'Test page', initialRoute);

  function Wrapper({ children }: { children: React.ReactNode }) {
    return (
      <QueryClientProvider client={queryClient}>
        <BrowserRouter>
          {children}
        </BrowserRouter>
      </QueryClientProvider>
    );
  }

  return render(ui, { wrapper: Wrapper, ...options });
}

// Re-export everything
export * from '@testing-library/react';
```

Usage:

```typescript
import { renderWithProviders, screen } from './test-utils';

test('component with providers', async () => {
  renderWithProviders(<CustomerList />, { initialRoute: '/customers' });
  
  expect(await screen.findByText('John Doe')).toBeInTheDocument();
});
```

## Mocking

### Mocking API Calls

```typescript
// Mock fetch
global.fetch = jest.fn();

beforeEach(() => {
  (fetch as jest.Mock).mockResolvedValue({
    ok: true,
    json: async () => [
      { id: 1, name: 'John' },
      { id: 2, name: 'Jane' },
    ],
  });
});

test('fetches and displays customers', async () => {
  render(<CustomerList />);
  
  expect(await screen.findByText('John')).toBeInTheDocument();
  expect(fetch).toHaveBeenCalledWith('/api/customers');
});
```

### Mocking Modules

```typescript
// Mock entire module
jest.mock('./api/customers', () => ({
  fetchCustomers: jest.fn(),
}));

import { fetchCustomers } from './api/customers';

test('uses mocked API', async () => {
  (fetchCustomers as jest.Mock).mockResolvedValue([
    { id: 1, name: 'John' },
  ]);
  
  render(<CustomerList />);
  
  expect(await screen.findByText('John')).toBeInTheDocument();
});
```

### Mocking React Router

```typescript
import { MemoryRouter } from 'react-router-dom';

test('navigation', async () => {
  const user = userEvent.setup();
  
  render(
    <MemoryRouter initialEntries={['/']}>
      <App />
    </MemoryRouter>
  );
  
  await user.click(screen.getByRole('link', { name: 'Customers' }));
  
  expect(screen.getByRole('heading', { name: 'Customers' })).toBeInTheDocument();
});
```

## Assertions

### jest-dom Matchers

```typescript
import '@testing-library/jest-dom';

// Visibility
expect(element).toBeInTheDocument();
expect(element).toBeVisible();
expect(element).not.toBeInTheDocument();

// Content
expect(element).toHaveTextContent('Hello');
expect(element).toContainHTML('<span>Hello</span>');

// Attributes
expect(element).toHaveAttribute('href', '/home');
expect(element).toHaveClass('active');
expect(element).toHaveStyle({ color: 'red' });

// Form elements
expect(input).toHaveValue('test@example.com');
expect(input).toBeDisabled();
expect(input).toBeEnabled();
expect(checkbox).toBeChecked();
expect(input).toHaveFocus();

// Accessibility
expect(button).toHaveAccessibleName('Submit');
expect(button).toHaveAccessibleDescription('Submit the form');
```

## Debugging

### screen.debug()

Print DOM structure.

```typescript
test('debug example', () => {
  render(<MyComponent />);
  
  // Print entire document
  screen.debug();
  
  // Print specific element
  screen.debug(screen.getByRole('button'));
  
  // Limit output
  screen.debug(undefined, 10000); // 10000 chars
});
```

### logRoles()

Print available roles.

```typescript
import { logRoles } from '@testing-library/react';

test('log roles', () => {
  const { container } = render(<MyComponent />);
  logRoles(container);
});
```

### Testing Playground

```typescript
import { screen } from '@testing-library/react';

test('get query suggestions', () => {
  render(<MyComponent />);
  
  screen.logTestingPlaygroundURL();
  // Opens browser with query suggestions
});
```

## Best Practices

### ✅ Do's

```typescript
// Use screen queries
screen.getByRole('button');

// Use user-event for interactions
await user.click(button);

// Use findBy for async
await screen.findByText('Loaded');

// Use accessible queries
screen.getByRole('button', { name: 'Submit' });

// Test user behavior
expect(screen.getByText('Success')).toBeInTheDocument();
```

### ❌ Don'ts

```typescript
// Don't use container queries
const { container } = render(<App />);
container.querySelector('.button'); // Bad

// Don't use fireEvent (use user-event)
fireEvent.click(button); // Bad

// Don't test implementation
expect(component.state.count).toBe(1); // Bad

// Don't use testID unless necessary
screen.getByTestId('button'); // Last resort

// Don't query by class/id
screen.getByClassName('button'); // Bad
```

## Summary

**Core Concepts**:
- Use `screen` for queries
- Query by accessibility (role, label, text)
- Use `user-event` for interactions
- Use `findBy` for async elements
- Test behavior, not implementation

**Query Priority**:
1. getByRole, getByLabelText
2. getByPlaceholderText, getByText
3. getByAltText, getByTitle
4. getByTestId (last resort)

**Key APIs**:
- `render()` - Render components
- `screen` - Query elements
- `userEvent` - Simulate interactions
- `waitFor()` - Wait for assertions
- `findBy` - Async queries

## Next Steps

1. Review [Testing Philosophy](./00-TESTING-PHILOSOPHY.md)
2. Review [TDD Refactoring Process](./01-TDD-REFACTORING-PROCESS.md)
3. Study [Best Practices](./03-BEST-PRACTICES.md)
4. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: React Testing Library helps you write tests that work the way your users do, making your tests more reliable and maintainable.
