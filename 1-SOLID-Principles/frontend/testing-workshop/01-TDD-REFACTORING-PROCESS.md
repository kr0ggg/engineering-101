# Test-Driven Refactoring Process for React

## Overview

Test-Driven Refactoring is a systematic approach to improving React code while maintaining functionality. This guide shows you how to safely refactor components using tests as a safety net.

## The TDD Refactoring Cycle

```
1. Write Characterization Tests
   ↓
2. Identify Code Smells
   ↓
3. Plan Refactoring
   ↓
4. Make Small Changes
   ↓
5. Run Tests
   ↓
6. Commit Frequently
   ↓
7. Review and Iterate
```

## Step 1: Write Characterization Tests

Before refactoring, write tests that capture current behavior (even if it's bad).

### Example: Monolithic Component

```typescript
// ProductDashboard.tsx - Violates SRP
function ProductDashboard() {
  const [products, setProducts] = useState<Product[]>([]);
  const [filter, setFilter] = useState('');
  const [sort, setSort] = useState<'name' | 'price'>('name');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    setLoading(true);
    fetch('/api/products')
      .then(res => res.json())
      .then(data => {
        setProducts(data);
        setLoading(false);
      })
      .catch(err => {
        setError(err.message);
        setLoading(false);
      });
  }, []);

  const filteredProducts = products.filter(p =>
    p.name.toLowerCase().includes(filter.toLowerCase())
  );

  const sortedProducts = [...filteredProducts].sort((a, b) => {
    if (sort === 'name') return a.name.localeCompare(b.name);
    return a.price - b.price;
  });

  return (
    <div>
      {loading && <div>Loading...</div>}
      {error && <div>Error: {error}</div>}
      <input
        placeholder="Filter products"
        value={filter}
        onChange={e => setFilter(e.target.value)}
      />
      <select value={sort} onChange={e => setSort(e.target.value as any)}>
        <option value="name">Name</option>
        <option value="price">Price</option>
      </select>
      <ul>
        {sortedProducts.map(p => (
          <li key={p.id}>
            {p.name} - ${p.price}
          </li>
        ))}
      </ul>
    </div>
  );
}
```

### Write Characterization Tests

```typescript
// ProductDashboard.test.tsx
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ProductDashboard } from './ProductDashboard';

// Mock fetch
global.fetch = jest.fn();

describe('ProductDashboard - Characterization Tests', () => {
  const mockProducts = [
    { id: 1, name: 'Widget', price: 10 },
    { id: 2, name: 'Gadget', price: 20 },
    { id: 3, name: 'Doohickey', price: 15 },
  ];

  beforeEach(() => {
    (fetch as jest.Mock).mockResolvedValue({
      json: async () => mockProducts,
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should show loading state initially', () => {
    render(<ProductDashboard />);
    expect(screen.getByText('Loading...')).toBeInTheDocument();
  });

  it('should display products after loading', async () => {
    render(<ProductDashboard />);
    
    await waitFor(() => {
      expect(screen.getByText('Widget - $10')).toBeInTheDocument();
    });
    
    expect(screen.getByText('Gadget - $20')).toBeInTheDocument();
    expect(screen.getByText('Doohickey - $15')).toBeInTheDocument();
  });

  it('should filter products by name', async () => {
    const user = userEvent.setup();
    render(<ProductDashboard />);
    
    await waitFor(() => {
      expect(screen.getByText('Widget - $10')).toBeInTheDocument();
    });
    
    await user.type(screen.getByPlaceholderText('Filter products'), 'gad');
    
    expect(screen.getByText('Gadget - $20')).toBeInTheDocument();
    expect(screen.queryByText('Widget - $10')).not.toBeInTheDocument();
  });

  it('should sort products by name', async () => {
    const user = userEvent.setup();
    render(<ProductDashboard />);
    
    await waitFor(() => {
      expect(screen.getByText('Widget - $10')).toBeInTheDocument();
    });
    
    const items = screen.getAllByRole('listitem');
    expect(items[0]).toHaveTextContent('Doohickey');
    expect(items[1]).toHaveTextContent('Gadget');
    expect(items[2]).toHaveTextContent('Widget');
  });

  it('should sort products by price', async () => {
    const user = userEvent.setup();
    render(<ProductDashboard />);
    
    await waitFor(() => {
      expect(screen.getByText('Widget - $10')).toBeInTheDocument();
    });
    
    await user.selectOptions(screen.getByRole('combobox'), 'price');
    
    const items = screen.getAllByRole('listitem');
    expect(items[0]).toHaveTextContent('Widget - $10');
    expect(items[1]).toHaveTextContent('Doohickey - $15');
    expect(items[2]).toHaveTextContent('Gadget - $20');
  });

  it('should display error message on fetch failure', async () => {
    (fetch as jest.Mock).mockRejectedValue(new Error('Network error'));
    
    render(<ProductDashboard />);
    
    await waitFor(() => {
      expect(screen.getByText('Error: Network error')).toBeInTheDocument();
    });
  });
});
```

## Step 2: Identify Code Smells

### Common React Code Smells

1. **Large Components** (> 200 lines)
2. **Multiple Responsibilities** (data fetching + filtering + sorting + rendering)
3. **Complex useEffect** (multiple concerns in one effect)
4. **Prop Drilling** (passing props through many levels)
5. **Duplicate Logic** (same code in multiple places)
6. **Tight Coupling** (hard to test or reuse)

### Analysis of ProductDashboard

```typescript
// Code Smells Identified:
// 1. ❌ Multiple responsibilities (SRP violation)
//    - Data fetching
//    - Filtering logic
//    - Sorting logic
//    - UI rendering
//
// 2. ❌ Large component (100+ lines)
//
// 3. ❌ Hard to test individual pieces
//
// 4. ❌ Hard to reuse filtering/sorting logic
```

## Step 3: Plan Refactoring

### Refactoring Strategy

1. Extract data fetching → `useProducts` hook
2. Extract filtering logic → `useProductFilter` hook
3. Extract sorting logic → `useProductSort` hook
4. Extract UI components → `ProductList`, `ProductFilters`

### Create Test Plan

```typescript
// Tests to write during refactoring:
// 1. useProducts hook tests
// 2. useProductFilter hook tests
// 3. useProductSort hook tests
// 4. ProductList component tests
// 5. ProductFilters component tests
// 6. Integration test for refactored ProductDashboard
```

## Step 4: Make Small Changes

### Refactoring Step 1: Extract Data Fetching Hook

```typescript
// hooks/useProducts.ts
export function useProducts() {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    setLoading(true);
    fetch('/api/products')
      .then(res => res.json())
      .then(data => {
        setProducts(data);
        setLoading(false);
      })
      .catch(err => {
        setError(err.message);
        setLoading(false);
      });
  }, []);

  return { products, loading, error };
}
```

```typescript
// hooks/useProducts.test.ts
import { renderHook, waitFor } from '@testing-library/react';
import { useProducts } from './useProducts';

global.fetch = jest.fn();

describe('useProducts', () => {
  const mockProducts = [
    { id: 1, name: 'Widget', price: 10 },
  ];

  beforeEach(() => {
    (fetch as jest.Mock).mockResolvedValue({
      json: async () => mockProducts,
    });
  });

  it('should fetch products on mount', async () => {
    const { result } = renderHook(() => useProducts());
    
    expect(result.current.loading).toBe(true);
    
    await waitFor(() => {
      expect(result.current.loading).toBe(false);
    });
    
    expect(result.current.products).toEqual(mockProducts);
    expect(result.current.error).toBeNull();
  });

  it('should handle fetch errors', async () => {
    (fetch as jest.Mock).mockRejectedValue(new Error('Network error'));
    
    const { result } = renderHook(() => useProducts());
    
    await waitFor(() => {
      expect(result.current.loading).toBe(false);
    });
    
    expect(result.current.error).toBe('Network error');
    expect(result.current.products).toEqual([]);
  });
});
```

### Refactoring Step 2: Extract Filtering Hook

```typescript
// hooks/useProductFilter.ts
export function useProductFilter(products: Product[]) {
  const [filter, setFilter] = useState('');

  const filteredProducts = useMemo(() => {
    if (!filter) return products;
    return products.filter(p =>
      p.name.toLowerCase().includes(filter.toLowerCase())
    );
  }, [products, filter]);

  return { filter, setFilter, filteredProducts };
}
```

```typescript
// hooks/useProductFilter.test.ts
import { renderHook, act } from '@testing-library/react';
import { useProductFilter } from './useProductFilter';

describe('useProductFilter', () => {
  const mockProducts = [
    { id: 1, name: 'Widget', price: 10 },
    { id: 2, name: 'Gadget', price: 20 },
  ];

  it('should return all products when filter is empty', () => {
    const { result } = renderHook(() => useProductFilter(mockProducts));
    
    expect(result.current.filteredProducts).toEqual(mockProducts);
  });

  it('should filter products by name', () => {
    const { result } = renderHook(() => useProductFilter(mockProducts));
    
    act(() => {
      result.current.setFilter('gad');
    });
    
    expect(result.current.filteredProducts).toEqual([
      { id: 2, name: 'Gadget', price: 20 },
    ]);
  });

  it('should be case insensitive', () => {
    const { result } = renderHook(() => useProductFilter(mockProducts));
    
    act(() => {
      result.current.setFilter('GAD');
    });
    
    expect(result.current.filteredProducts).toHaveLength(1);
  });
});
```

### Refactoring Step 3: Extract Sorting Hook

```typescript
// hooks/useProductSort.ts
export type SortOption = 'name' | 'price';

export function useProductSort(products: Product[]) {
  const [sort, setSort] = useState<SortOption>('name');

  const sortedProducts = useMemo(() => {
    return [...products].sort((a, b) => {
      if (sort === 'name') return a.name.localeCompare(b.name);
      return a.price - b.price;
    });
  }, [products, sort]);

  return { sort, setSort, sortedProducts };
}
```

```typescript
// hooks/useProductSort.test.ts
import { renderHook, act } from '@testing-library/react';
import { useProductSort } from './useProductSort';

describe('useProductSort', () => {
  const mockProducts = [
    { id: 1, name: 'Zebra', price: 30 },
    { id: 2, name: 'Apple', price: 10 },
    { id: 3, name: 'Mango', price: 20 },
  ];

  it('should sort by name by default', () => {
    const { result } = renderHook(() => useProductSort(mockProducts));
    
    expect(result.current.sortedProducts[0].name).toBe('Apple');
    expect(result.current.sortedProducts[1].name).toBe('Mango');
    expect(result.current.sortedProducts[2].name).toBe('Zebra');
  });

  it('should sort by price when selected', () => {
    const { result } = renderHook(() => useProductSort(mockProducts));
    
    act(() => {
      result.current.setSort('price');
    });
    
    expect(result.current.sortedProducts[0].price).toBe(10);
    expect(result.current.sortedProducts[1].price).toBe(20);
    expect(result.current.sortedProducts[2].price).toBe(30);
  });
});
```

### Refactoring Step 4: Extract UI Components

```typescript
// components/ProductFilters.tsx
interface ProductFiltersProps {
  filter: string;
  onFilterChange: (filter: string) => void;
  sort: SortOption;
  onSortChange: (sort: SortOption) => void;
}

export function ProductFilters({
  filter,
  onFilterChange,
  sort,
  onSortChange,
}: ProductFiltersProps) {
  return (
    <div>
      <input
        placeholder="Filter products"
        value={filter}
        onChange={e => onFilterChange(e.target.value)}
      />
      <select
        value={sort}
        onChange={e => onSortChange(e.target.value as SortOption)}
      >
        <option value="name">Name</option>
        <option value="price">Price</option>
      </select>
    </div>
  );
}
```

```typescript
// components/ProductFilters.test.tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ProductFilters } from './ProductFilters';

describe('ProductFilters', () => {
  it('should call onFilterChange when typing', async () => {
    const user = userEvent.setup();
    const onFilterChange = jest.fn();
    
    render(
      <ProductFilters
        filter=""
        onFilterChange={onFilterChange}
        sort="name"
        onSortChange={jest.fn()}
      />
    );
    
    await user.type(screen.getByPlaceholderText('Filter products'), 'test');
    
    expect(onFilterChange).toHaveBeenCalledWith('t');
  });

  it('should call onSortChange when selecting option', async () => {
    const user = userEvent.setup();
    const onSortChange = jest.fn();
    
    render(
      <ProductFilters
        filter=""
        onFilterChange={jest.fn()}
        sort="name"
        onSortChange={onSortChange}
      />
    );
    
    await user.selectOptions(screen.getByRole('combobox'), 'price');
    
    expect(onSortChange).toHaveBeenCalledWith('price');
  });
});
```

```typescript
// components/ProductList.tsx
interface ProductListProps {
  products: Product[];
  loading: boolean;
  error: string | null;
}

export function ProductList({ products, loading, error }: ProductListProps) {
  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <ul>
      {products.map(p => (
        <li key={p.id}>
          {p.name} - ${p.price}
        </li>
      ))}
    </ul>
  );
}
```

```typescript
// components/ProductList.test.tsx
import { render, screen } from '@testing-library/react';
import { ProductList } from './ProductList';

describe('ProductList', () => {
  const mockProducts = [
    { id: 1, name: 'Widget', price: 10 },
    { id: 2, name: 'Gadget', price: 20 },
  ];

  it('should display loading state', () => {
    render(<ProductList products={[]} loading={true} error={null} />);
    expect(screen.getByText('Loading...')).toBeInTheDocument();
  });

  it('should display error message', () => {
    render(<ProductList products={[]} loading={false} error="Network error" />);
    expect(screen.getByText('Error: Network error')).toBeInTheDocument();
  });

  it('should display products', () => {
    render(<ProductList products={mockProducts} loading={false} error={null} />);
    
    expect(screen.getByText('Widget - $10')).toBeInTheDocument();
    expect(screen.getByText('Gadget - $20')).toBeInTheDocument();
  });
});
```

### Refactoring Step 5: Compose Refactored Component

```typescript
// ProductDashboard.tsx - Refactored
export function ProductDashboard() {
  const { products, loading, error } = useProducts();
  const { filter, setFilter, filteredProducts } = useProductFilter(products);
  const { sort, setSort, sortedProducts } = useProductSort(filteredProducts);

  return (
    <div>
      <ProductFilters
        filter={filter}
        onFilterChange={setFilter}
        sort={sort}
        onSortChange={setSort}
      />
      <ProductList
        products={sortedProducts}
        loading={loading}
        error={error}
      />
    </div>
  );
}
```

## Step 5: Run Tests

```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Watch mode during refactoring
npm test -- --watch
```

**All original characterization tests should still pass!**

## Step 6: Commit Frequently

```bash
# After each successful refactoring step
git add .
git commit -m "Extract useProducts hook with tests"

git add .
git commit -m "Extract useProductFilter hook with tests"

git add .
git commit -m "Extract useProductSort hook with tests"

git add .
git commit -m "Extract ProductFilters component with tests"

git add .
git commit -m "Extract ProductList component with tests"

git add .
git commit -m "Compose refactored ProductDashboard"
```

## Step 7: Review and Iterate

### Benefits of Refactoring

**Before**:
- ❌ 100+ lines in one component
- ❌ Hard to test individual pieces
- ❌ Hard to reuse logic
- ❌ Violates SRP

**After**:
- ✅ Small, focused components (< 30 lines each)
- ✅ Easy to test in isolation
- ✅ Reusable hooks and components
- ✅ Follows SRP

### Metrics Comparison

```
Before Refactoring:
- Lines of code: 100
- Test coverage: 60%
- Cyclomatic complexity: 12
- Number of responsibilities: 5

After Refactoring:
- Lines of code: 120 (distributed across 6 files)
- Test coverage: 95%
- Cyclomatic complexity: 3 (average)
- Number of responsibilities: 1 per file
```

## Common Refactoring Patterns

### 1. Extract Custom Hook

**When**: Component has complex state logic

```typescript
// Before
function Component() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(false);
  // ... 20 lines of logic
}

// After
function useData() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(false);
  // ... 20 lines of logic
  return { data, loading };
}

function Component() {
  const { data, loading } = useData();
}
```

### 2. Extract Child Component

**When**: Component renders complex UI

```typescript
// Before
function Parent() {
  return (
    <div>
      <div>
        <h2>Title</h2>
        <p>Description</p>
        {/* 50 lines of JSX */}
      </div>
    </div>
  );
}

// After
function Header({ title, description }) {
  return (
    <div>
      <h2>{title}</h2>
      <p>{description}</p>
    </div>
  );
}

function Parent() {
  return (
    <div>
      <Header title="Title" description="Description" />
      {/* Cleaner parent */}
    </div>
  );
}
```

### 3. Extract Context Provider

**When**: Props are drilled through many levels

```typescript
// Before - Prop drilling
<Parent user={user}>
  <Child user={user}>
    <GrandChild user={user} />
  </Child>
</Parent>

// After - Context
const UserContext = createContext();

function UserProvider({ children }) {
  const [user, setUser] = useState(null);
  return (
    <UserContext.Provider value={{ user, setUser }}>
      {children}
    </UserContext.Provider>
  );
}

function GrandChild() {
  const { user } = useContext(UserContext);
}
```

## Summary

**TDD Refactoring Process**:
1. Write characterization tests
2. Identify code smells
3. Plan refactoring
4. Make small changes
5. Run tests
6. Commit frequently
7. Review and iterate

**Key Principles**:
- Tests enable safe refactoring
- Make small, incremental changes
- Keep tests passing
- Commit after each successful step
- Improve design without changing behavior

## Next Steps

1. Review [Testing Philosophy](./00-TESTING-PHILOSOPHY.md)
2. Learn [React Testing Library](./02-REACT-TESTING-LIBRARY.md)
3. Study [Best Practices](./03-BEST-PRACTICES.md)
4. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Tests are your safety net. Write them first, then refactor with confidence.
