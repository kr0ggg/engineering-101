# Frontend Testing Guide - React & TypeScript

## Overview

This guide covers testing strategies for React applications following SOLID principles. You'll learn how to use React Testing Library, Jest, and modern testing patterns to ensure your refactored code maintains functionality.

## Testing Stack

### Core Tools

- **Jest** - Test runner and assertion library
- **React Testing Library** - Component testing utilities
- **@testing-library/user-event** - User interaction simulation
- **@testing-library/jest-dom** - Custom Jest matchers

### Why React Testing Library?

React Testing Library encourages testing components the way users interact with them, which aligns perfectly with SOLID principles:

- Tests behavior, not implementation
- Promotes accessible components
- Encourages separation of concerns
- Makes refactoring safer

## Setup

The reference application is already configured with testing tools. To run tests:

```bash
cd frontend/reference-application/React

# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch

# Run tests with coverage
npm test -- --coverage

# Run specific test file
npm test ProductDashboard.test
```

## Testing Philosophy

### Test User Behavior, Not Implementation

```typescript
// ❌ BAD - Tests implementation details
expect(component.state.count).toBe(5);

// ✅ GOOD - Tests user-visible behavior
expect(screen.getByText('5 items')).toBeInTheDocument();
```

### Query Priority

Use queries in this order (from most to least preferred):

1. **getByRole** - Accessible to everyone (best)
2. **getByLabelText** - Form inputs
3. **getByPlaceholderText** - Form inputs (if no label)
4. **getByText** - Non-interactive elements
5. **getByDisplayValue** - Current form values
6. **getByAltText** - Images
7. **getByTitle** - Last resort
8. **getByTestId** - Only when nothing else works

## Testing Patterns by SOLID Principle

### 1. Single Responsibility Principle (SRP)

When refactoring components to follow SRP, test each responsibility independently.

#### Before Refactoring - Characterization Tests

```typescript
// ProductDashboard.test.tsx - Before refactoring
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ProductDashboard } from './ProductDashboard';

describe('ProductDashboard - Characterization Tests', () => {
  beforeEach(() => {
    // Mock the API
    global.fetch = jest.fn(() =>
      Promise.resolve({
        ok: true,
        json: () => Promise.resolve([
          { id: 1, name: 'Product A', price: 10.00 },
          { id: 2, name: 'Product B', price: 20.00 },
        ]),
      })
    ) as jest.Mock;
  });

  afterEach(() => {
    jest.restoreAllMocks();
  });

  it('should load and display products', async () => {
    render(<ProductDashboard />);
    
    expect(screen.getByText('Loading products...')).toBeInTheDocument();
    
    await waitFor(() => {
      expect(screen.getByText('Product A')).toBeInTheDocument();
      expect(screen.getByText('Product B')).toBeInTheDocument();
    });
  });

  it('should filter products by search term', async () => {
    render(<ProductDashboard />);
    
    await waitFor(() => {
      expect(screen.getByText('Product A')).toBeInTheDocument();
    });
    
    const searchInput = screen.getByPlaceholderText('Search products...');
    await userEvent.type(searchInput, 'Product A');
    
    expect(screen.getByText('Product A')).toBeInTheDocument();
    expect(screen.queryByText('Product B')).not.toBeInTheDocument();
  });

  it('should sort products by name', async () => {
    render(<ProductDashboard />);
    
    await waitFor(() => {
      expect(screen.getByText('Product A')).toBeInTheDocument();
    });
    
    const sortSelect = screen.getByRole('combobox');
    await userEvent.selectOptions(sortSelect, 'name');
    
    const products = screen.getAllByRole('heading', { level: 3 });
    expect(products[0]).toHaveTextContent('Product A');
    expect(products[1]).toHaveTextContent('Product B');
  });

  it('should add product to cart', async () => {
    render(<ProductDashboard />);
    
    await waitFor(() => {
      expect(screen.getByText('Product A')).toBeInTheDocument();
    });
    
    const addButton = screen.getAllByText('Add to Cart')[0];
    await userEvent.click(addButton);
    
    expect(screen.getByText('Shopping Cart (1 items)')).toBeInTheDocument();
    expect(screen.getByText(/Product A/)).toBeInTheDocument();
  });
});
```

#### After Refactoring - Component Tests

```typescript
// ProductList.test.tsx - After extracting component
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ProductList } from './ProductList';

describe('ProductList', () => {
  const mockProducts = [
    { id: 1, name: 'Product A', price: 10.00, description: 'Description A' },
    { id: 2, name: 'Product B', price: 20.00, description: 'Description B' },
  ];

  const mockOnAddToCart = jest.fn();

  it('should render list of products', () => {
    render(<ProductList products={mockProducts} onAddToCart={mockOnAddToCart} />);
    
    expect(screen.getByText('Product A')).toBeInTheDocument();
    expect(screen.getByText('Product B')).toBeInTheDocument();
    expect(screen.getByText('$10.00')).toBeInTheDocument();
    expect(screen.getByText('$20.00')).toBeInTheDocument();
  });

  it('should display empty message when no products', () => {
    render(<ProductList products={[]} onAddToCart={mockOnAddToCart} />);
    
    expect(screen.getByText('No products found')).toBeInTheDocument();
  });

  it('should call onAddToCart when button clicked', async () => {
    render(<ProductList products={mockProducts} onAddToCart={mockOnAddToCart} />);
    
    const addButtons = screen.getAllByText('Add to Cart');
    await userEvent.click(addButtons[0]);
    
    expect(mockOnAddToCart).toHaveBeenCalledWith(mockProducts[0]);
    expect(mockOnAddToCart).toHaveBeenCalledTimes(1);
  });
});
```

#### Custom Hook Tests

```typescript
// useProductFilter.test.ts - Testing extracted hook
import { renderHook, act } from '@testing-library/react';
import { useProductFilter } from './useProductFilter';

describe('useProductFilter', () => {
  const products = [
    { id: 1, name: 'Apple', price: 1.00 },
    { id: 2, name: 'Banana', price: 2.00 },
    { id: 3, name: 'Cherry', price: 3.00 },
  ];

  it('should return all products when search term is empty', () => {
    const { result } = renderHook(() => useProductFilter(products, ''));
    
    expect(result.current).toHaveLength(3);
  });

  it('should filter products by search term', () => {
    const { result } = renderHook(() => useProductFilter(products, 'app'));
    
    expect(result.current).toHaveLength(1);
    expect(result.current[0].name).toBe('Apple');
  });

  it('should be case-insensitive', () => {
    const { result } = renderHook(() => useProductFilter(products, 'BANANA'));
    
    expect(result.current).toHaveLength(1);
    expect(result.current[0].name).toBe('Banana');
  });

  it('should update when search term changes', () => {
    const { result, rerender } = renderHook(
      ({ products, searchTerm }) => useProductFilter(products, searchTerm),
      { initialProps: { products, searchTerm: 'app' } }
    );
    
    expect(result.current).toHaveLength(1);
    
    rerender({ products, searchTerm: 'ban' });
    
    expect(result.current).toHaveLength(1);
    expect(result.current[0].name).toBe('Banana');
  });
});
```

### 2. Open/Closed Principle (OCP)

Test that components are extensible without modification.

```typescript
// Button.test.tsx - Testing extensible component
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Button } from './Button';

describe('Button - Base Functionality', () => {
  it('should render children', () => {
    render(<Button>Click Me</Button>);
    expect(screen.getByText('Click Me')).toBeInTheDocument();
  });

  it('should call onClick when clicked', async () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click Me</Button>);
    
    await userEvent.click(screen.getByText('Click Me'));
    
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('should be disabled when disabled prop is true', () => {
    render(<Button disabled>Click Me</Button>);
    
    expect(screen.getByRole('button')).toBeDisabled();
  });
});

describe('Button - Extensibility', () => {
  it('should accept custom className', () => {
    render(<Button className="custom-class">Click Me</Button>);
    
    expect(screen.getByRole('button')).toHaveClass('custom-class');
  });

  it('should support different variants', () => {
    const { rerender } = render(<Button variant="primary">Primary</Button>);
    expect(screen.getByRole('button')).toHaveClass('btn-primary');
    
    rerender(<Button variant="secondary">Secondary</Button>);
    expect(screen.getByRole('button')).toHaveClass('btn-secondary');
  });

  it('should support different sizes', () => {
    const { rerender } = render(<Button size="small">Small</Button>);
    expect(screen.getByRole('button')).toHaveClass('btn-small');
    
    rerender(<Button size="large">Large</Button>);
    expect(screen.getByRole('button')).toHaveClass('btn-large');
  });

  it('should accept icon as child', () => {
    const Icon = () => <span data-testid="icon">🔍</span>;
    render(
      <Button>
        <Icon />
        Search
      </Button>
    );
    
    expect(screen.getByTestId('icon')).toBeInTheDocument();
    expect(screen.getByText('Search')).toBeInTheDocument();
  });
});
```

### 3. Liskov Substitution Principle (LSP)

Test that derived components can substitute base components.

```typescript
// Input.test.tsx - Base component contract tests
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Input } from './Input';
import { EmailInput } from './EmailInput';
import { NumberInput } from './NumberInput';

// Shared contract tests
const testInputContract = (InputComponent: React.ComponentType<any>) => {
  describe('Input Contract', () => {
    it('should render with value', () => {
      render(<InputComponent value="test" onChange={() => {}} />);
      expect(screen.getByDisplayValue('test')).toBeInTheDocument();
    });

    it('should call onChange when value changes', async () => {
      const handleChange = jest.fn();
      render(<InputComponent value="" onChange={handleChange} />);
      
      const input = screen.getByRole('textbox');
      await userEvent.type(input, 'a');
      
      expect(handleChange).toHaveBeenCalled();
    });

    it('should be disabled when disabled prop is true', () => {
      render(<InputComponent value="" onChange={() => {}} disabled />);
      expect(screen.getByRole('textbox')).toBeDisabled();
    });

    it('should display placeholder', () => {
      render(
        <InputComponent 
          value="" 
          onChange={() => {}} 
          placeholder="Enter text" 
        />
      );
      expect(screen.getByPlaceholderText('Enter text')).toBeInTheDocument();
    });
  });
};

describe('Input', () => {
  testInputContract(Input);
});

describe('EmailInput', () => {
  testInputContract(EmailInput);

  it('should validate email format', async () => {
    const handleChange = jest.fn();
    render(<EmailInput value="" onChange={handleChange} />);
    
    const input = screen.getByRole('textbox');
    await userEvent.type(input, 'invalid-email');
    
    // Should still call onChange (LSP compliance)
    expect(handleChange).toHaveBeenCalled();
  });
});

describe('NumberInput', () => {
  testInputContract(NumberInput);

  it('should accept only numbers', async () => {
    const handleChange = jest.fn();
    render(<NumberInput value="" onChange={handleChange} />);
    
    const input = screen.getByRole('textbox');
    await userEvent.type(input, '123');
    
    // Should call onChange with numeric value
    expect(handleChange).toHaveBeenCalled();
  });
});
```

### 4. Interface Segregation Principle (ISP)

Test components with minimal, focused prop interfaces.

```typescript
// UserProfile.test.tsx - Before ISP (fat interface)
describe('UserProfile - Fat Interface', () => {
  it('should render with all props', () => {
    const props = {
      userId: 1,
      name: 'John Doe',
      email: 'john@example.com',
      avatar: 'avatar.jpg',
      bio: 'Software developer',
      showAvatar: true,
      showBio: true,
      showEmail: true,
      onEdit: jest.fn(),
      onDelete: jest.fn(),
      isEditable: true,
      isDeletable: true,
    };
    
    render(<UserProfile {...props} />);
    // Component forced to handle many unused props
  });
});

// UserBasicInfo.test.tsx - After ISP (focused interface)
describe('UserBasicInfo', () => {
  it('should render user name and email', () => {
    render(
      <UserBasicInfo 
        name="John Doe" 
        email="john@example.com" 
      />
    );
    
    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
  });
});

// UserAvatar.test.tsx - Separate focused component
describe('UserAvatar', () => {
  it('should render avatar image', () => {
    render(<UserAvatar src="avatar.jpg" alt="John Doe" />);
    
    const img = screen.getByRole('img');
    expect(img).toHaveAttribute('src', 'avatar.jpg');
    expect(img).toHaveAttribute('alt', 'John Doe');
  });
});
```

### 5. Dependency Inversion Principle (DIP)

Test against abstractions using dependency injection.

```typescript
// useProductData.test.ts - Testing with injected dependencies
import { renderHook, waitFor } from '@testing-library/react';
import { useProductData } from './useProductData';
import { ProductService } from '../services/ProductService';

// Mock service implementation
class MockProductService implements ProductService {
  async getProducts() {
    return [
      { id: 1, name: 'Product A', price: 10.00 },
      { id: 2, name: 'Product B', price: 20.00 },
    ];
  }
}

class ErrorProductService implements ProductService {
  async getProducts() {
    throw new Error('Failed to fetch products');
  }
}

describe('useProductData', () => {
  it('should load products successfully', async () => {
    const mockService = new MockProductService();
    const { result } = renderHook(() => useProductData(mockService));
    
    expect(result.current.loading).toBe(true);
    
    await waitFor(() => {
      expect(result.current.loading).toBe(false);
    });
    
    expect(result.current.products).toHaveLength(2);
    expect(result.current.error).toBeNull();
  });

  it('should handle errors', async () => {
    const errorService = new ErrorProductService();
    const { result } = renderHook(() => useProductData(errorService));
    
    await waitFor(() => {
      expect(result.current.loading).toBe(false);
    });
    
    expect(result.current.error).toBe('Failed to fetch products');
    expect(result.current.products).toHaveLength(0);
  });
});

// ProductDashboard.test.tsx - Integration test with service injection
import { render, screen, waitFor } from '@testing-library/react';
import { ProductDashboard } from './ProductDashboard';
import { ProductServiceProvider } from '../context/ProductServiceContext';

describe('ProductDashboard - Integration', () => {
  it('should display products from service', async () => {
    const mockService = new MockProductService();
    
    render(
      <ProductServiceProvider value={mockService}>
        <ProductDashboard />
      </ProductServiceProvider>
    );
    
    await waitFor(() => {
      expect(screen.getByText('Product A')).toBeInTheDocument();
      expect(screen.getByText('Product B')).toBeInTheDocument();
    });
  });
});
```

## Mocking Strategies

### Mocking API Calls

```typescript
// Mock fetch globally
beforeEach(() => {
  global.fetch = jest.fn(() =>
    Promise.resolve({
      ok: true,
      json: () => Promise.resolve({ data: 'test' }),
    })
  ) as jest.Mock;
});

afterEach(() => {
  jest.restoreAllMocks();
});

// Or use MSW (Mock Service Worker) for more realistic mocking
import { rest } from 'msw';
import { setupServer } from 'msw/node';

const server = setupServer(
  rest.get('/api/products', (req, res, ctx) => {
    return res(ctx.json([
      { id: 1, name: 'Product A', price: 10.00 },
    ]));
  })
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

### Mocking Context

```typescript
import { render } from '@testing-library/react';
import { AuthContext } from '../context/AuthContext';

const renderWithAuth = (component: React.ReactElement, user = mockUser) => {
  return render(
    <AuthContext.Provider value={{ user, login: jest.fn(), logout: jest.fn() }}>
      {component}
    </AuthContext.Provider>
  );
};

// Usage
test('should display user name when logged in', () => {
  renderWithAuth(<UserProfile />, { id: 1, name: 'John Doe' });
  expect(screen.getByText('John Doe')).toBeInTheDocument();
});
```

### Mocking Hooks

```typescript
// Mock custom hook
jest.mock('../hooks/useProductData', () => ({
  useProductData: () => ({
    products: [{ id: 1, name: 'Test Product', price: 10.00 }],
    loading: false,
    error: null,
  }),
}));

// Or use jest.spyOn for more control
import * as hooks from '../hooks/useProductData';

jest.spyOn(hooks, 'useProductData').mockReturnValue({
  products: mockProducts,
  loading: false,
  error: null,
});
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
│   ├── useProductData.ts
│   └── useProductData.test.ts
├── services/
│   ├── ProductService.ts
│   └── ProductService.test.ts
└── test/
    ├── setup.ts
    ├── utils.tsx
    └── mocks/
        ├── handlers.ts
        └── server.ts
```

### Test Utilities

```typescript
// test/utils.tsx - Custom render function
import { render, RenderOptions } from '@testing-library/react';
import { BrowserRouter } from 'react-router-dom';
import { ProductServiceProvider } from '../context/ProductServiceContext';

const AllTheProviders = ({ children }: { children: React.ReactNode }) => {
  return (
    <BrowserRouter>
      <ProductServiceProvider value={mockProductService}>
        {children}
      </ProductServiceProvider>
    </BrowserRouter>
  );
};

const customRender = (
  ui: React.ReactElement,
  options?: Omit<RenderOptions, 'wrapper'>
) => render(ui, { wrapper: AllTheProviders, ...options });

export * from '@testing-library/react';
export { customRender as render };
```

## Running Tests

### Watch Mode
```bash
npm test -- --watch
```

### Coverage Report
```bash
npm test -- --coverage
```

### Update Snapshots
```bash
npm test -- -u
```

### Run Specific Test
```bash
npm test ProductList
```

### Debug Tests
```typescript
import { screen, debug } from '@testing-library/react';

test('debugging example', () => {
  render(<Component />);
  
  // Print entire DOM
  debug();
  
  // Print specific element
  debug(screen.getByRole('button'));
});
```

## Best Practices

### ✅ Do's

- Test user behavior, not implementation
- Use semantic queries (getByRole, getByLabelText)
- Write descriptive test names
- Keep tests independent
- Use setup/teardown appropriately
- Mock external dependencies
- Test edge cases and error states

### ❌ Don'ts

- Don't test implementation details
- Don't use getByTestId as first choice
- Don't make tests dependent on each other
- Don't test third-party libraries
- Don't over-mock (test real behavior when possible)
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

## Next Steps

1. Review [Testing Workshop](./TESTING-WORKSHOP.md) for principle-specific testing
2. Complete testing exercises for each SOLID principle
3. Use [Assessment Checklist](../ASSESSMENT-CHECKLIST.md) to validate your tests
4. Explore [Testing Best Practices](../TESTING-BEST-PRACTICES.md)

---

**Remember**: Good tests give you confidence to refactor. If refactoring breaks tests, that's a sign your tests might be testing implementation details rather than behavior.
