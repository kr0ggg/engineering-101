# Testing Philosophy for Frontend Development

## Overview

This guide establishes the foundational principles for testing React applications. Understanding these concepts will help you write effective tests that provide confidence in your code while remaining maintainable.

## Core Principles

### 1. Test Behavior, Not Implementation

**What to Test**: How users interact with your application
**What NOT to Test**: Internal component state, implementation details

```typescript
// ❌ Bad - Testing implementation details
test('should set loading state to true', () => {
  const { result } = renderHook(() => useCustomers());
  expect(result.current.loading).toBe(true);
});

// ✅ Good - Testing user-visible behavior
test('should show loading spinner while fetching customers', () => {
  render(<CustomerList />);
  expect(screen.getByRole('status')).toBeInTheDocument();
});
```

**Why**: Implementation can change without affecting user experience. Tests should survive refactoring.

### 2. Tests as Documentation

Tests should clearly communicate what the component does and how it should behave.

```typescript
// ✅ Good - Clear test name and structure
describe('CustomerList', () => {
  describe('when loading customers', () => {
    it('should display loading spinner', () => {
      // Test implementation
    });
  });
  
  describe('when customers are loaded', () => {
    it('should display customer names in alphabetical order', () => {
      // Test implementation
    });
    
    it('should allow filtering by email', () => {
      // Test implementation
    });
  });
  
  describe('when loading fails', () => {
    it('should display error message with retry button', () => {
      // Test implementation
    });
  });
});
```

### 3. Tests Enable Refactoring

Good tests give you confidence to refactor code without breaking functionality.

```typescript
// Before refactoring - monolithic component
function CustomerDashboard() {
  const [customers, setCustomers] = useState([]);
  const [filter, setFilter] = useState('');
  const [sort, setSort] = useState('name');
  // ... 200 lines of code
}

// After refactoring - extracted hooks and components
function CustomerDashboard() {
  const { customers, loading, error } = useCustomers();
  const { filter, setFilter } = useFilter();
  const { sort, setSort } = useSort();
  const filteredCustomers = useFilteredCustomers(customers, filter);
  const sortedCustomers = useSortedCustomers(filteredCustomers, sort);
  
  return (
    <>
      <CustomerFilters filter={filter} onFilterChange={setFilter} />
      <CustomerTable customers={sortedCustomers} sort={sort} onSortChange={setSort} />
    </>
  );
}

// Tests still pass because behavior hasn't changed!
```

### 4. Fast Feedback Loop

Tests should run quickly to provide immediate feedback during development.

**Target Times**:
- Unit tests: < 100ms each
- Integration tests: < 500ms each
- E2E tests: < 5 seconds each

```typescript
// ✅ Fast - Mock API calls
test('should display customers', async () => {
  mockAPI.getCustomers.mockResolvedValue([
    { id: 1, name: 'John' },
    { id: 2, name: 'Jane' },
  ]);
  
  render(<CustomerList />);
  
  expect(await screen.findByText('John')).toBeInTheDocument();
});

// ❌ Slow - Real API calls
test('should display customers', async () => {
  render(<CustomerList />);
  // Waits for real API response...
  expect(await screen.findByText('John', {}, { timeout: 5000 })).toBeInTheDocument();
});
```

### 5. Independent Tests

Each test should be able to run in isolation without depending on other tests.

```typescript
// ❌ Bad - Tests depend on each other
let customer;

test('should create customer', () => {
  customer = createCustomer({ name: 'John' });
  expect(customer.name).toBe('John');
});

test('should update customer', () => {
  customer.name = 'Jane';  // Depends on previous test!
  expect(customer.name).toBe('Jane');
});

// ✅ Good - Each test is independent
test('should create customer', () => {
  const customer = createCustomer({ name: 'John' });
  expect(customer.name).toBe('John');
});

test('should update customer', () => {
  const customer = createCustomer({ name: 'John' });
  customer.name = 'Jane';
  expect(customer.name).toBe('Jane');
});
```

## The Testing Pyramid for React

```
        /\
       /  \
      / E2E \          Few - Slow, expensive, brittle
     /______\
    /        \
   /Integration\       Some - Test component interactions
  /____________\
 /              \
/  Unit Tests    \     Many - Fast, cheap, reliable
/__________________\
```

### Unit Tests (70%)
Test individual components, hooks, and utilities in isolation.

```typescript
// Testing a single component
test('Button should call onClick when clicked', () => {
  const handleClick = jest.fn();
  render(<Button onClick={handleClick}>Click me</Button>);
  
  fireEvent.click(screen.getByRole('button'));
  
  expect(handleClick).toHaveBeenCalledTimes(1);
});

// Testing a custom hook
test('useCounter should increment count', () => {
  const { result } = renderHook(() => useCounter());
  
  act(() => {
    result.current.increment();
  });
  
  expect(result.current.count).toBe(1);
});
```

### Integration Tests (20%)
Test how components work together.

```typescript
test('CustomerForm should submit and display success message', async () => {
  const onSubmit = jest.fn();
  render(<CustomerForm onSubmit={onSubmit} />);
  
  // Fill form
  await userEvent.type(screen.getByLabelText('Name'), 'John Doe');
  await userEvent.type(screen.getByLabelText('Email'), 'john@example.com');
  
  // Submit
  await userEvent.click(screen.getByRole('button', { name: 'Submit' }));
  
  // Verify
  expect(onSubmit).toHaveBeenCalledWith({
    name: 'John Doe',
    email: 'john@example.com',
  });
  expect(screen.getByText('Customer created successfully')).toBeInTheDocument();
});
```

### E2E Tests (10%)
Test complete user workflows.

```typescript
test('User can create and view customer', async () => {
  // Navigate to create page
  await page.goto('http://localhost:3000/customers/new');
  
  // Fill form
  await page.fill('[name="name"]', 'John Doe');
  await page.fill('[name="email"]', 'john@example.com');
  await page.click('button[type="submit"]');
  
  // Verify redirect and display
  await expect(page).toHaveURL(/\/customers\/\d+/);
  await expect(page.locator('h1')).toContainText('John Doe');
});
```

## React Testing Library Philosophy

### Query Priority

Use queries in this order (most to least preferred):

1. **Accessible by everyone**: `getByRole`, `getByLabelText`, `getByPlaceholderText`, `getByText`
2. **Semantic queries**: `getByAltText`, `getByTitle`
3. **Test IDs**: `getByTestId` (last resort)

```typescript
// ✅ Best - Accessible to screen readers
screen.getByRole('button', { name: 'Submit' });
screen.getByLabelText('Email address');

// ⚠️ OK - Semantic but not accessible
screen.getByText('Submit');

// ❌ Last resort - Not user-facing
screen.getByTestId('submit-button');
```

### User-Centric Testing

Interact with components the way users do.

```typescript
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

test('should filter customers by name', async () => {
  const user = userEvent.setup();
  render(<CustomerList customers={mockCustomers} />);
  
  // Type like a real user
  await user.type(screen.getByPlaceholderText('Search customers'), 'John');
  
  // Verify visible results
  expect(screen.getByText('John Doe')).toBeInTheDocument();
  expect(screen.queryByText('Jane Smith')).not.toBeInTheDocument();
});
```

## AAA Pattern (Arrange-Act-Assert)

Structure every test with three clear sections:

```typescript
test('should add item to cart', async () => {
  // Arrange - Set up test data and render
  const user = userEvent.setup();
  const product = { id: 1, name: 'Widget', price: 10 };
  render(<ProductCard product={product} />);
  
  // Act - Perform user action
  await user.click(screen.getByRole('button', { name: 'Add to Cart' }));
  
  // Assert - Verify expected outcome
  expect(screen.getByText('Added to cart')).toBeInTheDocument();
});
```

## What to Test

### ✅ Do Test

1. **User interactions**
   - Clicking buttons
   - Typing in inputs
   - Selecting from dropdowns
   - Form submissions

2. **Conditional rendering**
   - Loading states
   - Error states
   - Empty states
   - Success states

3. **Data transformations**
   - Filtering lists
   - Sorting data
   - Formatting values
   - Calculations

4. **Accessibility**
   - ARIA labels
   - Keyboard navigation
   - Screen reader support

5. **Integration points**
   - API calls (mocked)
   - Router navigation
   - Context providers
   - Event handlers

### ❌ Don't Test

1. **Implementation details**
   - Component state
   - Internal functions
   - CSS classes (unless affecting behavior)
   - Prop types

2. **Third-party libraries**
   - React itself
   - UI libraries (Material-UI, Ant Design)
   - Utility libraries (lodash, date-fns)

3. **Trivial code**
   - Simple getters/setters
   - Pass-through props
   - Static content

## Common Anti-Patterns

### 1. Testing Implementation Details

```typescript
// ❌ Bad
test('should update state when button clicked', () => {
  const wrapper = shallow(<Counter />);
  wrapper.find('button').simulate('click');
  expect(wrapper.state('count')).toBe(1);
});

// ✅ Good
test('should increment count when button clicked', () => {
  render(<Counter />);
  fireEvent.click(screen.getByRole('button', { name: 'Increment' }));
  expect(screen.getByText('Count: 1')).toBeInTheDocument();
});
```

### 2. Testing Too Much in One Test

```typescript
// ❌ Bad - Testing everything
test('CustomerForm works', async () => {
  render(<CustomerForm />);
  // 50 lines of test code...
});

// ✅ Good - Focused tests
test('should validate email format', async () => {
  // Test one thing
});

test('should submit form with valid data', async () => {
  // Test another thing
});
```

### 3. Not Waiting for Async Updates

```typescript
// ❌ Bad - Not waiting for async
test('should display customers', () => {
  render(<CustomerList />);
  expect(screen.getByText('John Doe')).toBeInTheDocument(); // Fails!
});

// ✅ Good - Wait for async
test('should display customers', async () => {
  render(<CustomerList />);
  expect(await screen.findByText('John Doe')).toBeInTheDocument();
});
```

### 4. Using Wrong Query Methods

```typescript
// ❌ Bad - Using getBy for elements that might not exist
test('should not show error initially', () => {
  render(<Form />);
  expect(screen.getByText('Error')).not.toBeInTheDocument(); // Throws!
});

// ✅ Good - Using queryBy for elements that might not exist
test('should not show error initially', () => {
  render(<Form />);
  expect(screen.queryByText('Error')).not.toBeInTheDocument();
});
```

## Test Coverage Guidelines

### Aim for Meaningful Coverage, Not 100%

- **Critical paths**: 100% coverage
- **Business logic**: 90%+ coverage
- **UI components**: 70-80% coverage
- **Utilities**: 90%+ coverage

### What Coverage Doesn't Tell You

- Whether tests are good quality
- Whether you're testing the right things
- Whether tests will catch real bugs

```typescript
// ❌ Bad - 100% coverage but useless test
test('component renders', () => {
  render(<CustomerList />);
  expect(true).toBe(true);
});

// ✅ Good - Lower coverage but meaningful test
test('should display customer names', async () => {
  render(<CustomerList />);
  expect(await screen.findByText('John Doe')).toBeInTheDocument();
});
```

## Testing Mindset

### Think Like a User

- What would a user see?
- What would a user do?
- What would a user expect?

### Write Tests First (TDD)

1. Write a failing test
2. Write minimal code to pass
3. Refactor
4. Repeat

### Keep Tests Simple

- One assertion per test (when possible)
- Clear test names
- Minimal setup
- No complex logic in tests

## Summary

**Core Principles**:
- Test behavior, not implementation
- Tests are documentation
- Enable refactoring
- Fast feedback
- Independent tests

**Testing Pyramid**:
- Many unit tests (70%)
- Some integration tests (20%)
- Few E2E tests (10%)

**React Testing Library**:
- Query by accessibility
- Interact like users
- Wait for async updates

**AAA Pattern**:
- Arrange: Set up
- Act: User action
- Assert: Verify outcome

## Next Steps

1. Review [TDD Refactoring Process](./01-TDD-REFACTORING-PROCESS.md)
2. Learn [React Testing Library](./02-REACT-TESTING-LIBRARY.md)
3. Study [Best Practices](./03-BEST-PRACTICES.md)
4. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Write tests that give you confidence your application works for users, not tests that verify implementation details.
