# Single Responsibility Principle - Testing Workshop (React)

## Overview

This workshop teaches you how to use test-driven refactoring to apply the Single Responsibility Principle to React components. You'll learn to write characterization tests first, then refactor with confidence.

## Learning Objectives

By the end of this workshop, you will:
- Write characterization tests for existing code
- Refactor components using test-driven approach
- Test extracted components and hooks independently
- Maintain 100% test coverage during refactoring

## Prerequisites

- Completed [Frontend Testing Guide](../TESTING-GUIDE.md)
- Understanding of React Testing Library
- Basic knowledge of Jest

## The Test-Driven Refactoring Process

```
1. Write characterization tests (document current behavior)
   ↓
2. Ensure all tests pass (green)
   ↓
3. Identify responsibilities to extract
   ↓
4. Extract one responsibility
   ↓
5. Run tests - should still pass
   ↓
6. Write tests for extracted component/hook
   ↓
7. Repeat steps 4-6 until complete
   ↓
8. Review and improve test coverage
```

## Part 1: Characterization Tests

### What Are Characterization Tests?

Characterization tests document the **current behavior** of code, even if that code violates SOLID principles. They serve as a safety net during refactoring.

### Step 1.1: Analyze the Violating Component

Open `ProductDashboard.tsx` and identify its responsibilities:

1. ✅ Data fetching (useProductData hook)
2. ✅ Filtering logic (search term state and filtering)
3. ✅ Sorting logic (sort state and sorting)
4. ✅ Cart management (cart state and operations)
5. ✅ UI rendering (all JSX)
6. ✅ Error handling (error state display)
7. ✅ Loading state (loading state display)

**7 responsibilities = Violates SRP!**

### Step 1.2: Write Characterization Tests

Create `ProductDashboard.test.tsx`:

```typescript
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ProductDashboard } from './ProductDashboard';

// Mock the data fetching hook
jest.mock('../hooks/useProductData');
import { useProductData } from '../hooks/useProductData';

const mockProducts = [
  { id: 1, name: 'Apple', price: 1.00, description: 'Fresh apple' },
  { id: 2, name: 'Banana', price: 0.50, description: 'Yellow banana' },
  { id: 3, name: 'Cherry', price: 2.00, description: 'Sweet cherry' },
];

describe('ProductDashboard - Characterization Tests', () => {
  beforeEach(() => {
    // Setup default mock behavior
    (useProductData as jest.Mock).mockReturnValue({
      products: mockProducts,
      loading: false,
      error: null,
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('loading state', () => {
    it('should display loading message when loading', () => {
      (useProductData as jest.Mock).mockReturnValue({
        products: [],
        loading: true,
        error: null,
      });

      render(<ProductDashboard />);

      expect(screen.getByText('Loading products...')).toBeInTheDocument();
    });

    it('should not display products when loading', () => {
      (useProductData as jest.Mock).mockReturnValue({
        products: mockProducts,
        loading: true,
        error: null,
      });

      render(<ProductDashboard />);

      expect(screen.queryByText('Apple')).not.toBeInTheDocument();
    });
  });

  describe('error state', () => {
    it('should display error message when error occurs', () => {
      (useProductData as jest.Mock).mockReturnValue({
        products: [],
        loading: false,
        error: 'Failed to fetch products',
      });

      render(<ProductDashboard />);

      expect(screen.getByText('Error')).toBeInTheDocument();
      expect(screen.getByText('Failed to fetch products')).toBeInTheDocument();
    });

    it('should not display products when error occurs', () => {
      (useProductData as jest.Mock).mockReturnValue({
        products: mockProducts,
        loading: false,
        error: 'Failed to fetch products',
      });

      render(<ProductDashboard />);

      expect(screen.queryByText('Apple')).not.toBeInTheDocument();
    });
  });

  describe('product display', () => {
    it('should display all products', async () => {
      render(<ProductDashboard />);

      await waitFor(() => {
        expect(screen.getByText('Apple')).toBeInTheDocument();
        expect(screen.getByText('Banana')).toBeInTheDocument();
        expect(screen.getByText('Cherry')).toBeInTheDocument();
      });
    });

    it('should display product prices', () => {
      render(<ProductDashboard />);

      expect(screen.getByText('$1.00')).toBeInTheDocument();
      expect(screen.getByText('$0.50')).toBeInTheDocument();
      expect(screen.getByText('$2.00')).toBeInTheDocument();
    });

    it('should display product descriptions', () => {
      render(<ProductDashboard />);

      expect(screen.getByText('Fresh apple')).toBeInTheDocument();
      expect(screen.getByText('Yellow banana')).toBeInTheDocument();
      expect(screen.getByText('Sweet cherry')).toBeInTheDocument();
    });

    it('should display product count', () => {
      render(<ProductDashboard />);

      expect(screen.getByText('Products (3)')).toBeInTheDocument();
    });
  });

  describe('search functionality', () => {
    it('should filter products by search term', async () => {
      render(<ProductDashboard />);

      const searchInput = screen.getByPlaceholderText('Search products...');
      await userEvent.type(searchInput, 'app');

      expect(screen.getByText('Apple')).toBeInTheDocument();
      expect(screen.queryByText('Banana')).not.toBeInTheDocument();
      expect(screen.queryByText('Cherry')).not.toBeInTheDocument();
    });

    it('should be case-insensitive', async () => {
      render(<ProductDashboard />);

      const searchInput = screen.getByPlaceholderText('Search products...');
      await userEvent.type(searchInput, 'BANANA');

      expect(screen.getByText('Banana')).toBeInTheDocument();
      expect(screen.queryByText('Apple')).not.toBeInTheDocument();
    });

    it('should show "No products found" when no matches', async () => {
      render(<ProductDashboard />);

      const searchInput = screen.getByPlaceholderText('Search products...');
      await userEvent.type(searchInput, 'xyz');

      expect(screen.getByText('No products found')).toBeInTheDocument();
    });

    it('should update product count after filtering', async () => {
      render(<ProductDashboard />);

      const searchInput = screen.getByPlaceholderText('Search products...');
      await userEvent.type(searchInput, 'app');

      expect(screen.getByText('Products (1)')).toBeInTheDocument();
    });
  });

  describe('sort functionality', () => {
    it('should sort products by name', async () => {
      render(<ProductDashboard />);

      const sortSelect = screen.getByRole('combobox');
      await userEvent.selectOptions(sortSelect, 'name');

      const products = screen.getAllByRole('heading', { level: 3 });
      expect(products[0]).toHaveTextContent('Apple');
      expect(products[1]).toHaveTextContent('Banana');
      expect(products[2]).toHaveTextContent('Cherry');
    });

    it('should sort products by price', async () => {
      render(<ProductDashboard />);

      const sortSelect = screen.getByRole('combobox');
      await userEvent.selectOptions(sortSelect, 'price');

      const prices = screen.getAllByText(/\$\d+\.\d+/);
      expect(prices[0]).toHaveTextContent('$0.50');
      expect(prices[1]).toHaveTextContent('$1.00');
      expect(prices[2]).toHaveTextContent('$2.00');
    });
  });

  describe('cart functionality', () => {
    it('should start with empty cart', () => {
      render(<ProductDashboard />);

      expect(screen.getByText('Shopping Cart (0 items)')).toBeInTheDocument();
      expect(screen.getByText('Your cart is empty')).toBeInTheDocument();
    });

    it('should add product to cart', async () => {
      render(<ProductDashboard />);

      const addButtons = screen.getAllByText('Add to Cart');
      await userEvent.click(addButtons[0]);

      expect(screen.getByText('Shopping Cart (1 items)')).toBeInTheDocument();
      expect(screen.getByText('Apple')).toBeInTheDocument();
    });

    it('should increase quantity for existing item', async () => {
      render(<ProductDashboard />);

      const addButtons = screen.getAllByText('Add to Cart');
      await userEvent.click(addButtons[0]);
      await userEvent.click(addButtons[0]);

      const quantityDisplay = screen.getByText('2');
      expect(quantityDisplay).toBeInTheDocument();
    });

    it('should calculate cart total', async () => {
      render(<ProductDashboard />);

      const addButtons = screen.getAllByText('Add to Cart');
      await userEvent.click(addButtons[0]); // Apple $1.00
      await userEvent.click(addButtons[1]); // Banana $0.50

      expect(screen.getByText('Total: $1.50')).toBeInTheDocument();
    });

    it('should remove item from cart', async () => {
      render(<ProductDashboard />);

      const addButtons = screen.getAllByText('Add to Cart');
      await userEvent.click(addButtons[0]);

      const removeButton = screen.getByText('Remove');
      await userEvent.click(removeButton);

      expect(screen.getByText('Shopping Cart (0 items)')).toBeInTheDocument();
      expect(screen.getByText('Your cart is empty')).toBeInTheDocument();
    });

    it('should update quantity with controls', async () => {
      render(<ProductDashboard />);

      const addButtons = screen.getAllByText('Add to Cart');
      await userEvent.click(addButtons[0]);

      const increaseButton = screen.getByText('+');
      await userEvent.click(increaseButton);

      expect(screen.getByText('2')).toBeInTheDocument();
      expect(screen.getByText('Total: $2.00')).toBeInTheDocument();
    });

    it('should remove item when quantity reaches zero', async () => {
      render(<ProductDashboard />);

      const addButtons = screen.getAllByText('Add to Cart');
      await userEvent.click(addButtons[0]);

      const decreaseButton = screen.getByText('-');
      await userEvent.click(decreaseButton);

      expect(screen.getByText('Shopping Cart (0 items)')).toBeInTheDocument();
    });
  });

  describe('integration', () => {
    it('should filter and add filtered product to cart', async () => {
      render(<ProductDashboard />);

      // Filter products
      const searchInput = screen.getByPlaceholderText('Search products...');
      await userEvent.type(searchInput, 'app');

      // Add filtered product
      const addButton = screen.getByText('Add to Cart');
      await userEvent.click(addButton);

      // Verify cart
      expect(screen.getByText('Shopping Cart (1 items)')).toBeInTheDocument();
      expect(screen.getAllByText('Apple')).toHaveLength(2); // In list and cart
    });
  });
});
```

### Step 1.3: Run Tests

```bash
npm test ProductDashboard.test
```

**All tests should pass!** These tests document the current behavior.

## Part 2: Extract Custom Hooks

### Step 2.1: Extract useProductFilter Hook

**Identify**: Filtering logic is a separate responsibility.

**Create** `useProductFilter.ts`:

```typescript
import { useMemo } from 'react';
import type { Product } from '../types';

export function useProductFilter(products: Product[], searchTerm: string): Product[] {
  return useMemo(() => {
    if (!searchTerm) {
      return products;
    }
    
    return products.filter(product =>
      product.name.toLowerCase().includes(searchTerm.toLowerCase())
    );
  }, [products, searchTerm]);
}
```

**Create** `useProductFilter.test.ts`:

```typescript
import { renderHook } from '@testing-library/react';
import { useProductFilter } from './useProductFilter';

const mockProducts = [
  { id: 1, name: 'Apple', price: 1.00 },
  { id: 2, name: 'Banana', price: 0.50 },
  { id: 3, name: 'Cherry', price: 2.00 },
];

describe('useProductFilter', () => {
  it('should return all products when search term is empty', () => {
    const { result } = renderHook(() => 
      useProductFilter(mockProducts, '')
    );

    expect(result.current).toHaveLength(3);
    expect(result.current).toEqual(mockProducts);
  });

  it('should filter products by search term', () => {
    const { result } = renderHook(() => 
      useProductFilter(mockProducts, 'app')
    );

    expect(result.current).toHaveLength(1);
    expect(result.current[0].name).toBe('Apple');
  });

  it('should be case-insensitive', () => {
    const { result } = renderHook(() => 
      useProductFilter(mockProducts, 'BANANA')
    );

    expect(result.current).toHaveLength(1);
    expect(result.current[0].name).toBe('Banana');
  });

  it('should return empty array when no matches', () => {
    const { result } = renderHook(() => 
      useProductFilter(mockProducts, 'xyz')
    );

    expect(result.current).toHaveLength(0);
  });

  it('should update when search term changes', () => {
    const { result, rerender } = renderHook(
      ({ products, searchTerm }) => useProductFilter(products, searchTerm),
      { initialProps: { products: mockProducts, searchTerm: 'app' } }
    );

    expect(result.current).toHaveLength(1);

    rerender({ products: mockProducts, searchTerm: 'ban' });

    expect(result.current).toHaveLength(1);
    expect(result.current[0].name).toBe('Banana');
  });

  it('should update when products change', () => {
    const { result, rerender } = renderHook(
      ({ products, searchTerm }) => useProductFilter(products, searchTerm),
      { initialProps: { products: mockProducts, searchTerm: 'app' } }
    );

    expect(result.current).toHaveLength(1);

    const newProducts = [
      { id: 4, name: 'Apricot', price: 1.50 },
      { id: 5, name: 'Apple Pie', price: 5.00 },
    ];

    rerender({ products: newProducts, searchTerm: 'app' });

    expect(result.current).toHaveLength(2);
  });
});
```

**Update** `ProductDashboard.tsx` to use the hook:

```typescript
import { useProductFilter } from '../hooks/useProductFilter';

export const ProductDashboard: React.FC = () => {
  const { products, loading, error } = useProductData();
  const [searchTerm, setSearchTerm] = useState('');
  
  // Use extracted hook instead of inline logic
  const filteredProducts = useProductFilter(products, searchTerm);
  
  // Rest of component...
};
```

**Run tests**:

```bash
npm test
```

**All tests should still pass!** The behavior hasn't changed.

### Step 2.2: Extract useProductSort Hook

**Create** `useProductSort.ts`:

```typescript
import { useMemo } from 'react';
import type { Product, SortOption } from '../types';

export function useProductSort(products: Product[], sortBy: SortOption): Product[] {
  return useMemo(() => {
    return [...products].sort((a, b) => {
      if (sortBy === 'name') {
        return a.name.localeCompare(b.name);
      }
      return a.price - b.price;
    });
  }, [products, sortBy]);
}
```

**Create** `useProductSort.test.ts`:

```typescript
import { renderHook } from '@testing-library/react';
import { useProductSort } from './useProductSort';

const mockProducts = [
  { id: 3, name: 'Cherry', price: 2.00 },
  { id: 1, name: 'Apple', price: 1.00 },
  { id: 2, name: 'Banana', price: 0.50 },
];

describe('useProductSort', () => {
  it('should sort products by name', () => {
    const { result } = renderHook(() => 
      useProductSort(mockProducts, 'name')
    );

    expect(result.current[0].name).toBe('Apple');
    expect(result.current[1].name).toBe('Banana');
    expect(result.current[2].name).toBe('Cherry');
  });

  it('should sort products by price', () => {
    const { result } = renderHook(() => 
      useProductSort(mockProducts, 'price')
    );

    expect(result.current[0].price).toBe(0.50);
    expect(result.current[1].price).toBe(1.00);
    expect(result.current[2].price).toBe(2.00);
  });

  it('should not mutate original array', () => {
    const original = [...mockProducts];
    const { result } = renderHook(() => 
      useProductSort(mockProducts, 'name')
    );

    expect(mockProducts).toEqual(original);
    expect(result.current).not.toBe(mockProducts);
  });

  it('should update when sort option changes', () => {
    const { result, rerender } = renderHook(
      ({ products, sortBy }) => useProductSort(products, sortBy),
      { initialProps: { products: mockProducts, sortBy: 'name' as const } }
    );

    expect(result.current[0].name).toBe('Apple');

    rerender({ products: mockProducts, sortBy: 'price' as const });

    expect(result.current[0].price).toBe(0.50);
  });
});
```

### Step 2.3: Extract useCart Hook

**Create** `useCart.ts`:

```typescript
import { useState, useCallback, useMemo } from 'react';
import type { Product, CartItem } from '../types';

export function useCart() {
  const [cart, setCart] = useState<CartItem[]>([]);

  const addToCart = useCallback((product: Product) => {
    setCart(prev => {
      const existing = prev.find(item => item.id === product.id);
      if (existing) {
        return prev.map(item =>
          item.id === product.id
            ? { ...item, quantity: item.quantity + 1 }
            : item
        );
      }
      return [...prev, { 
        id: product.id, 
        name: product.name, 
        price: product.price, 
        quantity: 1,
        productId: product.id
      }];
    });
  }, []);

  const removeFromCart = useCallback((productId: number) => {
    setCart(prev => prev.filter(item => item.id !== productId));
  }, []);

  const updateQuantity = useCallback((productId: number, quantity: number) => {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    setCart(prev =>
      prev.map(item =>
        item.id === productId ? { ...item, quantity } : item
      )
    );
  }, [removeFromCart]);

  const total = useMemo(() => {
    return cart.reduce((sum, item) => sum + item.price * item.quantity, 0);
  }, [cart]);

  return {
    cart,
    addToCart,
    removeFromCart,
    updateQuantity,
    total,
  };
}
```

**Create** `useCart.test.ts`:

```typescript
import { renderHook, act } from '@testing-library/react';
import { useCart } from './useCart';

const mockProduct = {
  id: 1,
  name: 'Test Product',
  price: 10.00,
  description: 'Test',
};

describe('useCart', () => {
  it('should start with empty cart', () => {
    const { result } = renderHook(() => useCart());

    expect(result.current.cart).toHaveLength(0);
    expect(result.current.total).toBe(0);
  });

  it('should add product to cart', () => {
    const { result } = renderHook(() => useCart());

    act(() => {
      result.current.addToCart(mockProduct);
    });

    expect(result.current.cart).toHaveLength(1);
    expect(result.current.cart[0].name).toBe('Test Product');
    expect(result.current.cart[0].quantity).toBe(1);
  });

  it('should increase quantity for existing product', () => {
    const { result } = renderHook(() => useCart());

    act(() => {
      result.current.addToCart(mockProduct);
      result.current.addToCart(mockProduct);
    });

    expect(result.current.cart).toHaveLength(1);
    expect(result.current.cart[0].quantity).toBe(2);
  });

  it('should calculate total correctly', () => {
    const { result } = renderHook(() => useCart());

    act(() => {
      result.current.addToCart(mockProduct);
      result.current.addToCart(mockProduct);
    });

    expect(result.current.total).toBe(20.00);
  });

  it('should remove product from cart', () => {
    const { result } = renderHook(() => useCart());

    act(() => {
      result.current.addToCart(mockProduct);
      result.current.removeFromCart(mockProduct.id);
    });

    expect(result.current.cart).toHaveLength(0);
  });

  it('should update quantity', () => {
    const { result } = renderHook(() => useCart());

    act(() => {
      result.current.addToCart(mockProduct);
      result.current.updateQuantity(mockProduct.id, 5);
    });

    expect(result.current.cart[0].quantity).toBe(5);
    expect(result.current.total).toBe(50.00);
  });

  it('should remove item when quantity set to zero', () => {
    const { result } = renderHook(() => useCart());

    act(() => {
      result.current.addToCart(mockProduct);
      result.current.updateQuantity(mockProduct.id, 0);
    });

    expect(result.current.cart).toHaveLength(0);
  });
});
```

**Run all tests**:

```bash
npm test
```

**All tests should pass!**

## Part 3: Extract UI Components

### Step 3.1: Extract ProductList Component

**Create** `ProductList.tsx`:

```typescript
import React from 'react';
import type { Product } from '../types';

interface ProductListProps {
  products: Product[];
  onAddToCart: (product: Product) => void;
}

export const ProductList: React.FC<ProductListProps> = ({ products, onAddToCart }) => {
  if (products.length === 0) {
    return <p>No products found</p>;
  }

  return (
    <div className="products-grid">
      {products.map(product => (
        <div key={product.id} className="product-card">
          <h3>{product.name}</h3>
          <p className="price">${product.price.toFixed(2)}</p>
          {product.description && <p className="description">{product.description}</p>}
          <button
            onClick={() => onAddToCart(product)}
            className="add-to-cart-btn"
          >
            Add to Cart
          </button>
        </div>
      ))}
    </div>
  );
};
```

**Create** `ProductList.test.tsx`:

```typescript
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ProductList } from './ProductList';

const mockProducts = [
  { id: 1, name: 'Apple', price: 1.00, description: 'Fresh' },
  { id: 2, name: 'Banana', price: 0.50, description: 'Yellow' },
];

describe('ProductList', () => {
  const mockOnAddToCart = jest.fn();

  beforeEach(() => {
    mockOnAddToCart.mockClear();
  });

  it('should render list of products', () => {
    render(<ProductList products={mockProducts} onAddToCart={mockOnAddToCart} />);

    expect(screen.getByText('Apple')).toBeInTheDocument();
    expect(screen.getByText('Banana')).toBeInTheDocument();
  });

  it('should display product prices', () => {
    render(<ProductList products={mockProducts} onAddToCart={mockOnAddToCart} />);

    expect(screen.getByText('$1.00')).toBeInTheDocument();
    expect(screen.getByText('$0.50')).toBeInTheDocument();
  });

  it('should display product descriptions', () => {
    render(<ProductList products={mockProducts} onAddToCart={mockOnAddToCart} />);

    expect(screen.getByText('Fresh')).toBeInTheDocument();
    expect(screen.getByText('Yellow')).toBeInTheDocument();
  });

  it('should call onAddToCart when button clicked', async () => {
    render(<ProductList products={mockProducts} onAddToCart={mockOnAddToCart} />);

    const addButtons = screen.getAllByText('Add to Cart');
    await userEvent.click(addButtons[0]);

    expect(mockOnAddToCart).toHaveBeenCalledWith(mockProducts[0]);
    expect(mockOnAddToCart).toHaveBeenCalledTimes(1);
  });

  it('should display empty message when no products', () => {
    render(<ProductList products={[]} onAddToCart={mockOnAddToCart} />);

    expect(screen.getByText('No products found')).toBeInTheDocument();
  });
});
```

### Step 3.2: Extract ShoppingCart Component

**Create** `ShoppingCart.tsx` and `ShoppingCart.test.tsx` following the same pattern.

### Step 3.3: Update ProductDashboard

Now `ProductDashboard` becomes a simple orchestrator:

```typescript
export const ProductDashboard: React.FC = () => {
  const { products, loading, error } = useProductData();
  const [searchTerm, setSearchTerm] = useState('');
  const [sortBy, setSortBy] = useState<SortOption>('name');
  
  const filteredProducts = useProductFilter(products, searchTerm);
  const sortedProducts = useProductSort(filteredProducts, sortBy);
  const { cart, addToCart, removeFromCart, updateQuantity, total } = useCart();

  if (error) return <ErrorDisplay error={error} />;
  if (loading) return <LoadingDisplay />;

  return (
    <div className="product-dashboard">
      <h1>Product Dashboard</h1>
      
      <SearchAndSort
        searchTerm={searchTerm}
        onSearchChange={setSearchTerm}
        sortBy={sortBy}
        onSortChange={setSortBy}
      />

      <ProductList 
        products={sortedProducts} 
        onAddToCart={addToCart} 
      />

      <ShoppingCart
        cart={cart}
        total={total}
        onRemove={removeFromCart}
        onUpdateQuantity={updateQuantity}
      />
    </div>
  );
};
```

**Run all tests**:

```bash
npm test
```

**All tests should still pass!**

## Part 4: Verify and Improve

### Step 4.1: Check Test Coverage

```bash
npm test -- --coverage
```

**Target**: > 80% coverage for all files

### Step 4.2: Review Test Quality

Use the [Assessment Checklist](../../ASSESSMENT-CHECKLIST.md) to verify:

- [ ] Each component/hook has focused tests
- [ ] Tests are independent
- [ ] Tests are fast (< 1 second each)
- [ ] Edge cases covered
- [ ] Error conditions tested

### Step 4.3: Refactor Tests

Look for opportunities to improve tests:

- Extract common setup into helper functions
- Use test builders for complex objects
- Add missing edge case tests
- Improve test names

## Summary

You've successfully:

✅ Written characterization tests for violating code
✅ Extracted responsibilities into focused hooks
✅ Extracted UI into focused components
✅ Maintained 100% passing tests throughout
✅ Achieved better test coverage
✅ Created maintainable, testable code

## Next Steps

1. Complete [Assessment Checklist](../../ASSESSMENT-CHECKLIST.md)
2. Request peer review using [Code Review Guidelines](../../CODE-REVIEW-GUIDELINES.md)
3. Move to next principle: [Open/Closed Principle](../2-Open-closed-principle/TESTING-WORKSHOP.md)

## Resources

- [Frontend Testing Guide](../TESTING-GUIDE.md)
- [Testing Best Practices](../../TESTING-BEST-PRACTICES.md)
- [Assessment Checklist](../../ASSESSMENT-CHECKLIST.md)

---

**Remember**: Tests are your safety net. Write them first, keep them green, and refactor with confidence!
