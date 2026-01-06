# Frontend Testing Best Practices

## Overview

This guide covers best practices for testing React applications, helping you write maintainable, reliable, and effective tests.

## Core Principles

### 1. Test Behavior, Not Implementation

**Focus on what users see and do, not how the code works internally.**

```typescript
// ❌ Bad - Testing implementation
test('updates state when button clicked', () => {
  const wrapper = shallow(<Counter />);
  wrapper.find('button').simulate('click');
  expect(wrapper.state('count')).toBe(1);
});

// ✅ Good - Testing behavior
test('increments count when button clicked', async () => {
  const user = userEvent.setup();
  render(<Counter />);
  
  await user.click(screen.getByRole('button', { name: 'Increment' }));
  
  expect(screen.getByText('Count: 1')).toBeInTheDocument();
});
```

### 2. Write Tests That Resemble User Interactions

**Use the same queries and actions that users would.**

```typescript
// ❌ Bad - Using implementation details
const input = container.querySelector('#email-input');
fireEvent.change(input, { target: { value: 'test@example.com' } });

// ✅ Good - Using accessible queries and realistic interactions
await user.type(
  screen.getByLabelText('Email address'),
  'test@example.com'
);
```

### 3. Avoid Testing Implementation Details

**Don't test internal state, private functions, or component structure.**

```typescript
// ❌ Bad - Testing internal state
expect(component.state.loading).toBe(true);
expect(component.instance().validateEmail()).toBe(true);

// ✅ Good - Testing visible behavior
expect(screen.getByRole('status')).toBeInTheDocument();
expect(screen.queryByText('Invalid email')).not.toBeInTheDocument();
```

## Test Organization

### Describe Blocks

Use nested describe blocks for clear organization.

```typescript
describe('CustomerForm', () => {
  describe('validation', () => {
    it('should show error when email is invalid', async () => {
      // Test
    });
    
    it('should show error when name is empty', async () => {
      // Test
    });
  });
  
  describe('submission', () => {
    it('should call onSubmit with form data', async () => {
      // Test
    });
    
    it('should show success message after submission', async () => {
      // Test
    });
  });
  
  describe('loading state', () => {
    it('should disable submit button while loading', async () => {
      // Test
    });
  });
});
```

### Test Naming

Use descriptive test names that explain what is being tested.

```typescript
// ❌ Bad - Unclear names
test('works', () => {});
test('test1', () => {});
test('button', () => {});

// ✅ Good - Clear, descriptive names
test('should display error message when email is invalid', () => {});
test('should submit form when all fields are valid', () => {});
test('should disable submit button while form is submitting', () => {});
```

### Setup and Teardown

Use beforeEach/afterEach for common setup.

```typescript
describe('CustomerList', () => {
  let mockFetch: jest.Mock;
  
  beforeEach(() => {
    mockFetch = jest.fn().mockResolvedValue({
      ok: true,
      json: async () => [
        { id: 1, name: 'John' },
        { id: 2, name: 'Jane' },
      ],
    });
    global.fetch = mockFetch;
  });
  
  afterEach(() => {
    jest.clearAllMocks();
  });
  
  it('should fetch customers on mount', async () => {
    render(<CustomerList />);
    expect(await screen.findByText('John')).toBeInTheDocument();
  });
});
```

## Query Best Practices

### Query Priority

Always use the most accessible query available.

```typescript
// ✅ Best - Accessible queries
screen.getByRole('button', { name: 'Submit' });
screen.getByLabelText('Email address');
screen.getByPlaceholderText('Search...');
screen.getByText('Welcome');

// ⚠️ OK - Semantic queries
screen.getByAltText('Profile picture');
screen.getByTitle('Close');

// ❌ Last resort - Test IDs
screen.getByTestId('submit-button');
```

### When to Use Each Query Type

```typescript
// getBy - Element must exist
const button = screen.getByRole('button');

// queryBy - Element might not exist
const error = screen.queryByText('Error');
expect(error).not.toBeInTheDocument();

// findBy - Element appears asynchronously
const data = await screen.findByText('Loaded data');

// getAllBy - Multiple elements must exist
const items = screen.getAllByRole('listitem');
expect(items).toHaveLength(3);

// queryAllBy - Multiple elements might not exist
const errors = screen.queryAllByRole('alert');
expect(errors).toHaveLength(0);

// findAllBy - Multiple elements appear asynchronously
const items = await screen.findAllByRole('listitem');
```

## Async Testing

### Use findBy for Async Elements

```typescript
// ❌ Bad - Using getBy for async content
test('displays data', () => {
  render(<DataComponent />);
  expect(screen.getByText('Data loaded')).toBeInTheDocument(); // Fails!
});

// ✅ Good - Using findBy
test('displays data', async () => {
  render(<DataComponent />);
  expect(await screen.findByText('Data loaded')).toBeInTheDocument();
});
```

### Use waitFor for Complex Assertions

```typescript
test('updates multiple elements', async () => {
  render(<Dashboard />);
  
  await waitFor(() => {
    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('jane@example.com')).toBeInTheDocument();
    expect(screen.getByText('Active')).toBeInTheDocument();
  });
});
```

### Don't Use act() Directly

React Testing Library handles act() automatically.

```typescript
// ❌ Bad - Manual act()
act(() => {
  render(<Component />);
});

// ✅ Good - RTL handles it
render(<Component />);
await user.click(button);
```

## User Interactions

### Use userEvent Over fireEvent

```typescript
// ❌ Bad - fireEvent doesn't simulate real interactions
fireEvent.click(button);
fireEvent.change(input, { target: { value: 'test' } });

// ✅ Good - userEvent simulates real user behavior
const user = userEvent.setup();
await user.click(button);
await user.type(input, 'test');
```

### Setup userEvent Once

```typescript
test('user interactions', async () => {
  const user = userEvent.setup();
  render(<Form />);
  
  await user.type(screen.getByLabelText('Name'), 'John');
  await user.type(screen.getByLabelText('Email'), 'john@example.com');
  await user.click(screen.getByRole('button', { name: 'Submit' }));
});
```

### Test Realistic User Flows

```typescript
test('complete registration flow', async () => {
  const user = userEvent.setup();
  render(<RegistrationForm />);
  
  // Fill form like a real user
  await user.type(screen.getByLabelText('Name'), 'John Doe');
  await user.type(screen.getByLabelText('Email'), 'john@example.com');
  await user.type(screen.getByLabelText('Password'), 'SecurePass123');
  
  // Accept terms
  await user.click(screen.getByRole('checkbox', { name: 'Accept terms' }));
  
  // Submit
  await user.click(screen.getByRole('button', { name: 'Register' }));
  
  // Verify success
  expect(await screen.findByText('Registration successful')).toBeInTheDocument();
});
```

## Mocking

### Mock at the Right Level

```typescript
// ✅ Good - Mock API calls
global.fetch = jest.fn().mockResolvedValue({
  ok: true,
  json: async () => ({ data: 'test' }),
});

// ✅ Good - Mock modules
jest.mock('./api/customers', () => ({
  fetchCustomers: jest.fn(),
}));

// ❌ Bad - Don't mock React internals
jest.mock('react', () => ({
  ...jest.requireActual('react'),
  useState: jest.fn(),
}));
```

### Reset Mocks Between Tests

```typescript
describe('CustomerList', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });
  
  // Or use afterEach
  afterEach(() => {
    jest.restoreAllMocks();
  });
});
```

### Mock Only What You Need

```typescript
// ❌ Bad - Mocking too much
jest.mock('./CustomerService');
jest.mock('./ValidationService');
jest.mock('./FormattingService');

// ✅ Good - Mock only external dependencies
global.fetch = jest.fn();
```

## Testing Patterns

### Testing Forms

```typescript
test('form validation and submission', async () => {
  const user = userEvent.setup();
  const onSubmit = jest.fn();
  render(<CustomerForm onSubmit={onSubmit} />);
  
  // Submit empty form
  await user.click(screen.getByRole('button', { name: 'Submit' }));
  
  // Check validation errors
  expect(screen.getByText('Name is required')).toBeInTheDocument();
  expect(screen.getByText('Email is required')).toBeInTheDocument();
  
  // Fill valid data
  await user.type(screen.getByLabelText('Name'), 'John Doe');
  await user.type(screen.getByLabelText('Email'), 'john@example.com');
  
  // Errors should clear
  expect(screen.queryByText('Name is required')).not.toBeInTheDocument();
  
  // Submit valid form
  await user.click(screen.getByRole('button', { name: 'Submit' }));
  
  // Verify submission
  expect(onSubmit).toHaveBeenCalledWith({
    name: 'John Doe',
    email: 'john@example.com',
  });
});
```

### Testing Lists

```typescript
test('renders and filters list', async () => {
  const user = userEvent.setup();
  render(<CustomerList />);
  
  // Wait for data to load
  const items = await screen.findAllByRole('listitem');
  expect(items).toHaveLength(3);
  
  // Filter list
  await user.type(screen.getByPlaceholderText('Search'), 'John');
  
  // Verify filtered results
  expect(screen.getByText('John Doe')).toBeInTheDocument();
  expect(screen.queryByText('Jane Smith')).not.toBeInTheDocument();
});
```

### Testing Modals/Dialogs

```typescript
test('opens and closes modal', async () => {
  const user = userEvent.setup();
  render(<App />);
  
  // Modal not visible
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument();
  
  // Open modal
  await user.click(screen.getByRole('button', { name: 'Open' }));
  
  // Modal visible
  const dialog = screen.getByRole('dialog');
  expect(dialog).toBeInTheDocument();
  expect(within(dialog).getByText('Modal Content')).toBeInTheDocument();
  
  // Close modal
  await user.click(within(dialog).getByRole('button', { name: 'Close' }));
  
  // Modal removed
  await waitForElementToBeRemoved(dialog);
});
```

### Testing Error States

```typescript
test('displays error message on failure', async () => {
  global.fetch = jest.fn().mockRejectedValue(new Error('Network error'));
  
  render(<CustomerList />);
  
  // Wait for error
  expect(await screen.findByText('Failed to load customers')).toBeInTheDocument();
  expect(screen.getByText('Network error')).toBeInTheDocument();
  
  // Verify retry button
  expect(screen.getByRole('button', { name: 'Retry' })).toBeInTheDocument();
});
```

### Testing Loading States

```typescript
test('shows loading indicator', async () => {
  render(<CustomerList />);
  
  // Loading indicator visible
  expect(screen.getByRole('status')).toBeInTheDocument();
  expect(screen.getByText('Loading...')).toBeInTheDocument();
  
  // Wait for data
  await screen.findByText('John Doe');
  
  // Loading indicator gone
  expect(screen.queryByRole('status')).not.toBeInTheDocument();
});
```

## Custom Render Functions

### Create Reusable Test Utilities

```typescript
// test-utils.tsx
import { render, RenderOptions } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { BrowserRouter } from 'react-router-dom';

interface CustomRenderOptions extends RenderOptions {
  initialRoute?: string;
  queryClient?: QueryClient;
}

export function renderWithProviders(
  ui: React.ReactElement,
  {
    initialRoute = '/',
    queryClient = new QueryClient({
      defaultOptions: {
        queries: { retry: false },
        mutations: { retry: false },
      },
    }),
    ...options
  }: CustomRenderOptions = {}
) {
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

  return {
    ...render(ui, { wrapper: Wrapper, ...options }),
    queryClient,
  };
}

export * from '@testing-library/react';
export { userEvent } from '@testing-library/user-event';
```

Usage:

```typescript
import { renderWithProviders, screen } from './test-utils';

test('component with providers', async () => {
  renderWithProviders(<CustomerList />, { initialRoute: '/customers' });
  
  expect(await screen.findByText('John Doe')).toBeInTheDocument();
});
```

## Accessibility Testing

### Test ARIA Attributes

```typescript
test('has proper ARIA attributes', () => {
  render(<Button onClick={jest.fn()}>Submit</Button>);
  
  const button = screen.getByRole('button', { name: 'Submit' });
  expect(button).toHaveAccessibleName('Submit');
  expect(button).not.toHaveAttribute('aria-disabled');
});
```

### Test Keyboard Navigation

```typescript
test('supports keyboard navigation', async () => {
  const user = userEvent.setup();
  render(<Form />);
  
  // Tab through form
  await user.tab();
  expect(screen.getByLabelText('Name')).toHaveFocus();
  
  await user.tab();
  expect(screen.getByLabelText('Email')).toHaveFocus();
  
  await user.tab();
  expect(screen.getByRole('button', { name: 'Submit' })).toHaveFocus();
  
  // Submit with Enter
  await user.keyboard('{Enter}');
});
```

### Test Screen Reader Support

```typescript
test('provides screen reader feedback', async () => {
  const user = userEvent.setup();
  render(<Form />);
  
  await user.type(screen.getByLabelText('Email'), 'invalid');
  await user.click(screen.getByRole('button', { name: 'Submit' }));
  
  // Error should be announced
  const error = screen.getByRole('alert');
  expect(error).toHaveTextContent('Invalid email format');
});
```

## Performance Testing

### Avoid Unnecessary Re-renders

```typescript
test('does not re-render unnecessarily', () => {
  const renderSpy = jest.fn();
  
  function TestComponent() {
    renderSpy();
    return <div>Test</div>;
  }
  
  const { rerender } = render(<TestComponent />);
  expect(renderSpy).toHaveBeenCalledTimes(1);
  
  rerender(<TestComponent />);
  expect(renderSpy).toHaveBeenCalledTimes(1); // Should not increase
});
```

### Test Debouncing/Throttling

```typescript
test('debounces search input', async () => {
  const user = userEvent.setup();
  const onSearch = jest.fn();
  render(<SearchInput onSearch={onSearch} debounceMs={300} />);
  
  // Type quickly
  await user.type(screen.getByRole('textbox'), 'test');
  
  // Should not call immediately
  expect(onSearch).not.toHaveBeenCalled();
  
  // Wait for debounce
  await waitFor(() => {
    expect(onSearch).toHaveBeenCalledWith('test');
  });
  
  // Should only call once
  expect(onSearch).toHaveBeenCalledTimes(1);
});
```

## Common Mistakes

### 1. Not Waiting for Async Updates

```typescript
// ❌ Bad
test('displays data', () => {
  render(<AsyncComponent />);
  expect(screen.getByText('Data')).toBeInTheDocument(); // Fails!
});

// ✅ Good
test('displays data', async () => {
  render(<AsyncComponent />);
  expect(await screen.findByText('Data')).toBeInTheDocument();
});
```

### 2. Using Wrong Query for Non-Existent Elements

```typescript
// ❌ Bad - getBy throws error
expect(screen.getByText('Error')).not.toBeInTheDocument(); // Throws!

// ✅ Good - queryBy returns null
expect(screen.queryByText('Error')).not.toBeInTheDocument();
```

### 3. Testing Implementation Details

```typescript
// ❌ Bad
expect(component.state.count).toBe(1);
expect(component.find('.button')).toHaveLength(1);

// ✅ Good
expect(screen.getByText('Count: 1')).toBeInTheDocument();
expect(screen.getByRole('button')).toBeInTheDocument();
```

### 4. Not Cleaning Up

```typescript
// ❌ Bad - Mocks persist between tests
global.fetch = jest.fn();

// ✅ Good - Clean up after each test
afterEach(() => {
  jest.clearAllMocks();
});
```

### 5. Over-Mocking

```typescript
// ❌ Bad - Mocking too much
jest.mock('./Component1');
jest.mock('./Component2');
jest.mock('./Component3');

// ✅ Good - Mock only external dependencies
global.fetch = jest.fn();
```

## Test Coverage

### Aim for Meaningful Coverage

```typescript
// ❌ Bad - High coverage, low value
test('component renders', () => {
  render(<Component />);
  expect(true).toBe(true); // Useless
});

// ✅ Good - Lower coverage, high value
test('displays error when submission fails', async () => {
  // Tests actual user-facing behavior
});
```

### Focus on Critical Paths

- ✅ User registration/login
- ✅ Payment processing
- ✅ Data submission
- ✅ Error handling
- ⚠️ UI styling (less critical)
- ⚠️ Static content (less critical)

## Summary

**Core Best Practices**:
- Test behavior, not implementation
- Use accessible queries
- Interact like users with userEvent
- Wait for async updates with findBy/waitFor
- Mock at the right level
- Clean up between tests

**Query Priority**:
1. getByRole, getByLabelText
2. getByPlaceholderText, getByText
3. getByTestId (last resort)

**Common Patterns**:
- Forms: validation + submission
- Lists: rendering + filtering
- Modals: open + close
- Async: loading + error states
- Accessibility: ARIA + keyboard

**Avoid**:
- Testing implementation details
- Using wrong query types
- Not waiting for async
- Over-mocking
- Not cleaning up

## Next Steps

1. Review [Testing Philosophy](./00-TESTING-PHILOSOPHY.md)
2. Review [TDD Refactoring Process](./01-TDD-REFACTORING-PROCESS.md)
3. Review [React Testing Library](./02-REACT-TESTING-LIBRARY.md)
4. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Write tests that give you confidence your application works for real users. Focus on behavior, use accessible queries, and keep tests maintainable.
