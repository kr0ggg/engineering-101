# Frontend Testing Workshop - React & TypeScript

## Overview

This workshop teaches you how to write effective tests while applying SOLID principles to React applications. You'll learn test-driven refactoring, component testing, and how to validate that your refactored code maintains functionality while improving design.

## Workshop Structure

### Core Concepts
- [Testing Philosophy](./00-TESTING-PHILOSOPHY.md)
- [Test-Driven Refactoring Process](./01-TDD-REFACTORING-PROCESS.md)
- [React Testing Library Guide](./02-REACT-TESTING-LIBRARY.md)
- [Testing Best Practices](./03-BEST-PRACTICES.md)

### SOLID Principle Testing Workshops

Each SOLID principle has a dedicated hands-on testing workshop:

1. [Single Responsibility Principle Testing](./srp/README.md)
2. [Open/Closed Principle Testing](./ocp/README.md)
3. [Liskov Substitution Principle Testing](./lsp/README.md)
4. [Interface Segregation Principle Testing](./isp/README.md)
5. [Dependency Inversion Principle Testing](./dip/README.md)

## Quick Start

### 1. Complete Setup

Ensure you have the React reference application set up:

```bash
cd frontend/reference-application/React
npm install
npm test
```

### 2. Learn Core Concepts

Read through the core concepts to understand the testing philosophy and approach:
- Testing Philosophy
- TDD Refactoring Process
- React Testing Library Guide
- Best Practices

### 3. Start with SRP

Begin with the Single Responsibility Principle testing workshop. It provides a complete example of test-driven refactoring.

### 4. Progress Through Principles

Work through each SOLID principle in order:
- SRP → OCP → LSP → ISP → DIP

### 5. Use Assessment Tools

After each principle, use the assessment checklist to validate your work.

## Testing Stack

### Core Tools
- **Jest** - Test runner and assertion library
- **React Testing Library** - Component testing utilities
- **@testing-library/user-event** - User interaction simulation
- **@testing-library/jest-dom** - Custom Jest matchers
- **@testing-library/react-hooks** - Hook testing utilities

### Why React Testing Library?

React Testing Library encourages testing components the way users interact with them:
- Tests behavior, not implementation
- Promotes accessible components
- Encourages separation of concerns
- Makes refactoring safer

## Learning Path

```
1. Read Testing Philosophy
   ↓
2. Understand TDD Refactoring Process
   ↓
3. Learn React Testing Library
   ↓
4. Study Best Practices
   ↓
5. Apply to SRP Exercise
   ↓
6. Continue through OCP, LSP, ISP, DIP
   ↓
7. Use Assessment Checklist
```

## Key Principles

### Test User Behavior, Not Implementation

```typescript
// ❌ Bad - Tests implementation details
expect(component.state.count).toBe(5);

// ✅ Good - Tests user-visible behavior
expect(screen.getByText('5 items')).toBeInTheDocument();
```

### Follow Arrange-Act-Assert

```typescript
test('should add item to cart', async () => {
  // Arrange - Set up test data
  render(<ProductDashboard />);
  
  // Act - Execute user action
  await userEvent.click(screen.getByText('Add to Cart'));
  
  // Assert - Verify outcome
  expect(screen.getByText('Shopping Cart (1 items)')).toBeInTheDocument();
});
```

### Keep Tests Independent

Each test should:
- Run independently
- Not depend on other tests
- Clean up after itself
- Be repeatable

### Write Descriptive Names

```typescript
// ❌ Bad
test('works', () => { });

// ✅ Good
test('should display error message when API call fails', () => { });
```

## Running Tests

### Run All Tests
```bash
npm test
```

### Watch Mode
```bash
npm test -- --watch
```

### Coverage Report
```bash
npm test -- --coverage
```

### Run Specific Test
```bash
npm test ProductDashboard
```

### Debug Tests
```bash
npm test -- --no-coverage --verbose
```

## Testing Patterns by SOLID Principle

### Single Responsibility Principle
- Test each component/hook independently
- Extract logic into testable hooks
- Separate concerns for easier testing

### Open/Closed Principle
- Test base behavior remains unchanged
- Test extensions independently
- Verify polymorphic behavior

### Liskov Substitution Principle
- Use contract tests for all implementations
- Verify component substitutability
- Test behavioral compatibility

### Interface Segregation Principle
- Test focused prop interfaces
- Minimal test doubles
- Component specialization

### Dependency Inversion Principle
- Test against abstractions
- Easy mocking with dependency injection
- Test with multiple implementations

## Common Testing Scenarios

### Testing Components

```typescript
import { render, screen } from '@testing-library/react';
import { ProductList } from './ProductList';

test('should render list of products', () => {
  const products = [
    { id: 1, name: 'Apple', price: 1.00 },
    { id: 2, name: 'Banana', price: 0.50 },
  ];
  
  render(<ProductList products={products} onAddToCart={jest.fn()} />);
  
  expect(screen.getByText('Apple')).toBeInTheDocument();
  expect(screen.getByText('Banana')).toBeInTheDocument();
});
```

### Testing Custom Hooks

```typescript
import { renderHook, act } from '@testing-library/react';
import { useCart } from './useCart';

test('should add item to cart', () => {
  const { result } = renderHook(() => useCart());
  
  act(() => {
    result.current.addItem({ id: 1, name: 'Apple', price: 1.00 });
  });
  
  expect(result.current.items).toHaveLength(1);
});
```

### Testing User Interactions

```typescript
import userEvent from '@testing-library/user-event';

test('should filter products when typing in search', async () => {
  render(<ProductDashboard />);
  
  const searchInput = screen.getByPlaceholderText('Search products...');
  await userEvent.type(searchInput, 'apple');
  
  expect(screen.getByText('Apple')).toBeInTheDocument();
  expect(screen.queryByText('Banana')).not.toBeInTheDocument();
});
```

### Testing Async Operations

```typescript
import { waitFor } from '@testing-library/react';

test('should load products from API', async () => {
  render(<ProductDashboard />);
  
  await waitFor(() => {
    expect(screen.getByText('Apple')).toBeInTheDocument();
  });
});
```

### Mocking Dependencies

```typescript
// Mock API service
jest.mock('../services/api', () => ({
  fetchProducts: jest.fn(() => Promise.resolve([
    { id: 1, name: 'Apple', price: 1.00 },
  ])),
}));

// Mock custom hook
jest.mock('../hooks/useProductData', () => ({
  useProductData: () => ({
    products: mockProducts,
    loading: false,
    error: null,
  }),
}));
```

## Test Organization

### File Structure

```
src/
├── components/
│   ├── ProductList.tsx
│   ├── ProductList.test.tsx
│   ├── ProductCard.tsx
│   └── ProductCard.test.tsx
├── hooks/
│   ├── useCart.ts
│   └── useCart.test.ts
├── services/
│   ├── api.ts
│   └── api.test.ts
└── test/
    ├── setup.ts
    ├── utils.tsx
    └── mocks/
```

### Test Suite Organization

```typescript
describe('ProductDashboard', () => {
  describe('loading state', () => {
    it('should display loading message');
    it('should not display products');
  });
  
  describe('error state', () => {
    it('should display error message');
    it('should not display products');
  });
  
  describe('product display', () => {
    it('should render all products');
    it('should display prices');
  });
});
```

## Mocking Strategies

### Mock API Calls

```typescript
// Using jest.mock
jest.mock('../services/api');

// Using MSW (Mock Service Worker)
import { rest } from 'msw';
import { setupServer } from 'msw/node';

const server = setupServer(
  rest.get('/api/products', (req, res, ctx) => {
    return res(ctx.json(mockProducts));
  })
);
```

### Mock Context

```typescript
import { render } from '@testing-library/react';
import { ProductServiceContext } from '../context/ProductServiceContext';

const renderWithContext = (component, mockService) => {
  return render(
    <ProductServiceContext.Provider value={mockService}>
      {component}
    </ProductServiceContext.Provider>
  );
};
```

### Mock Hooks

```typescript
jest.mock('../hooks/useProductData', () => ({
  useProductData: () => ({
    products: mockProducts,
    loading: false,
    error: null,
  }),
}));
```

## Test Coverage Guidelines

### What to Test

✅ **Always Test**:
- Component rendering
- User interactions
- State changes
- API calls
- Error conditions
- Edge cases

✅ **Usually Test**:
- Complex logic in hooks
- Data transformations
- Validation rules
- Conditional rendering

⚠️ **Consider Testing**:
- Simple presentational components
- Styling logic
- Animation triggers

❌ **Don't Test**:
- Third-party libraries
- React internals
- CSS styles (use visual regression testing)

### Coverage Targets

- **Minimum**: 70% code coverage
- **Target**: 80-90% code coverage
- **Focus**: 100% coverage of business logic

## Best Practices

### ✅ Do's

- Test user behavior, not implementation
- Use semantic queries (getByRole, getByLabelText)
- Write descriptive test names
- Keep tests independent
- Mock external dependencies
- Test edge cases and error states
- Use setup/teardown appropriately

### ❌ Don'ts

- Don't test implementation details
- Don't use getByTestId as first choice
- Don't make tests dependent on each other
- Don't test third-party libraries
- Don't over-mock
- Don't write brittle tests

## Troubleshooting

### Common Issues

**Issue**: "Unable to find element"
```typescript
// Use waitFor for async operations
await waitFor(() => {
  expect(screen.getByText('Loaded')).toBeInTheDocument();
});
```

**Issue**: "Act warnings"
```typescript
// Wrap state updates in act
import { act } from '@testing-library/react';

act(() => {
  // Code that updates state
});
```

**Issue**: "Tests pass individually but fail together"
```typescript
// Clean up after each test
afterEach(() => {
  cleanup();
  jest.clearAllMocks();
});
```

## Resources

### Core Documentation
- [Testing Philosophy](./00-TESTING-PHILOSOPHY.md)
- [TDD Refactoring Process](./01-TDD-REFACTORING-PROCESS.md)
- [React Testing Library Guide](./02-REACT-TESTING-LIBRARY.md)
- [Best Practices](./03-BEST-PRACTICES.md)

### SOLID Workshops
- [SRP Testing Workshop](./srp/README.md)
- [OCP Testing Workshop](./ocp/README.md)
- [LSP Testing Workshop](./lsp/README.md)
- [ISP Testing Workshop](./isp/README.md)
- [DIP Testing Workshop](./dip/README.md)

### Assessment
- [Frontend Assessment Checklist](../assessment/CHECKLIST.md)
- [Code Review Guidelines](../assessment/CODE-REVIEW-GUIDELINES.md)

### External Resources
- [React Testing Library Docs](https://testing-library.com/react)
- [Jest Documentation](https://jestjs.io/)
- [Testing Best Practices](https://kentcdodds.com/blog/common-mistakes-with-react-testing-library)

## Support

If you encounter issues:
1. Check the troubleshooting section
2. Review the testing best practices
3. Consult the assessment checklist
4. Ask for help from instructor or peers

## Next Steps

1. **Read core concepts** to understand the approach
2. **Complete setup** for the React reference application
3. **Start with SRP** testing workshop
4. **Progress through** all SOLID principles
5. **Use assessment checklist** after each principle

---

**Ready to begin?** Start with [Testing Philosophy](./00-TESTING-PHILOSOPHY.md)!
