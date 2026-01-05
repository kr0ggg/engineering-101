# Single Responsibility Principle (SRP) - React Edition

## Name
**Single Responsibility Principle** - The "S" in SOLID

> **🖥️ Backend Developers**: This is the React/frontend-focused version. For backend/server-side content, see the [Backend Edition](../../backend/1-Single-class-reponsibility-principle/README.md).

## Goal of the Principle

In React, the Single Responsibility Principle means: **Each component, hook, or service should have only one reason to change**. Each should encapsulate a single concept or functionality, making the code more maintainable, testable, and understandable.

## React-Specific Application

### What It Means in React

In React development, SRP applies to:

- **Components**: Each component should have one purpose (display, input, container, etc.)
- **Hooks**: Each hook should handle one concern (data fetching, state management, side effects, etc.)
- **Services**: Each service should have one responsibility (API calls, validation, formatting, etc.)
- **Utilities**: Each utility function should do one thing

### React Component Responsibilities

A React component should have a **single, well-defined purpose**. Common responsibilities include:

- **Display**: Rendering UI based on props
- **Data Fetching**: Loading data from APIs
- **State Management**: Managing component state
- **Business Logic**: Processing data, calculations
- **Event Handling**: Responding to user interactions
- **Formatting**: Transforming data for display

**The Problem**: When a component handles multiple of these responsibilities, it becomes difficult to:
- Understand what the component does
- Test the component in isolation
- Reuse the component in different contexts
- Modify one responsibility without affecting others

## Theoretical Foundation

### Cognitive Load Theory in React

When a React component has multiple responsibilities, developers must simultaneously track:
- Multiple state variables
- Multiple useEffect hooks
- Multiple event handlers
- Multiple rendering concerns

This increases mental effort and error probability. By limiting each component to a single responsibility, we reduce the cognitive burden.

### Separation of Concerns in React

React's component model naturally supports separation of concerns:
- **Custom Hooks**: Extract data fetching and state logic
- **Component Composition**: Build complex UIs from simple components
- **Service Layers**: Separate business logic from UI

### Change Impact Analysis

Different responsibilities change for different reasons:
- **Data fetching** changes when API endpoints change
- **Filtering logic** changes when search requirements change
- **UI rendering** changes when design requirements change
- **Cart management** changes when business rules change

By separating these, we minimize the ripple effects of changes.

## Consequences of Violating SRP in React

### React-Specific Issues

**Multiple Responsibility Coupling**
- Changes to data fetching logic can break UI rendering
- Bug fixes in filtering can affect cart management
- New features require understanding multiple unrelated concepts in one file

**Cognitive Load and Complexity**
- Developers must track multiple useState hooks
- Multiple useEffect hooks with different dependencies
- Complex component logic that's hard to follow
- Difficult to understand component's primary purpose

**Testing and Reusability Problems**
- Components with multiple responsibilities require complex test scenarios
- Cannot reuse data fetching logic without the UI
- Cannot reuse UI components without the business logic
- Forces developers to accept unnecessary dependencies

**Component Size and Maintainability**
- Large components (500+ lines) become hard to maintain
- Difficult to locate specific functionality
- Merge conflicts when multiple developers work on the same component
- Reduced code readability and self-documentation

## React-Specific Examples

### ❌ Violating SRP - Mono-Component Example

The `ProductDashboard` component in our reference application violates SRP by handling **7 different responsibilities**:

**Location**: `frontend/reference-application/React/src/components/ProductDashboard.tsx`

```typescript
// ProductDashboard.tsx - VIOLATES SRP
// This component handles: data fetching, filtering, sorting, rendering, cart management
export const ProductDashboard: React.FC = () => {
  // Responsibility 1: Data Fetching (should be in a hook)
  const { products, loading, error } = useProductData();
  
  // Responsibility 2: Filtering State (should be separate)
  const [searchTerm, setSearchTerm] = useState('');
  const [filteredProducts, setFilteredProducts] = useState<Product[]>([]);
  
  // Responsibility 3: Sorting State (should be separate)
  const [sortBy, setSortBy] = useState<SortOption>('name');
  
  // Responsibility 4: Cart Management (should be separate)
  const [cart, setCart] = useState<CartItem[]>([]);

  // Responsibility 2: Filtering Logic (should be in a hook)
  useEffect(() => {
    const filtered = products.filter(product =>
      product.name.toLowerCase().includes(searchTerm.toLowerCase())
    );
    setFilteredProducts(filtered);
  }, [products, searchTerm]);

  // Responsibility 3: Sorting Logic (should be in a hook)
  const sortedProducts = useMemo(() => {
    return [...filteredProducts].sort((a, b) => {
      if (sortBy === 'name') {
        return a.name.localeCompare(b.name);
      }
      return a.price - b.price;
    });
  }, [filteredProducts, sortBy]);

  // Responsibility 4: Cart Management Logic (should be in a hook)
  const addToCart = (product: Product) => {
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
  };

  const removeFromCart = (productId: number) => {
    setCart(prev => prev.filter(item => item.id !== productId));
  };

  const updateCartQuantity = (productId: number, quantity: number) => {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    setCart(prev =>
      prev.map(item =>
        item.id === productId ? { ...item, quantity } : item
      )
    );
  };

  const cartTotal = useMemo(() => {
    return cart.reduce((total, item) => total + item.price * item.quantity, 0);
  }, [cart]);

  // Responsibility 5: Error Handling (should be separate component)
  if (error) {
    return (
      <div className="error-container">
        <h2>Error</h2>
        <p>{error}</p>
      </div>
    );
  }

  // Responsibility 6: Loading State (should be separate component)
  if (loading) {
    return (
      <div className="loading-container">
        <p>Loading products...</p>
      </div>
    );
  }

  // Responsibility 7: UI Rendering (should be split into multiple components)
  return (
    <div className="product-dashboard">
      <h1>Product Dashboard</h1>
      
      {/* Search and Sort Controls - should be separate components */}
      <div className="controls">
        <input
          type="text"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          placeholder="Search products..."
        />
        <select
          value={sortBy}
          onChange={(e) => setSortBy(e.target.value as SortOption)}
        >
          <option value="name">Sort by Name</option>
          <option value="price">Sort by Price</option>
        </select>
      </div>

      {/* Product List - should be separate component */}
      <div className="product-list">
        <h2>Products ({sortedProducts.length})</h2>
        {sortedProducts.map(product => (
          <div key={product.id} className="product-card">
            <h3>{product.name}</h3>
            <p>${product.price.toFixed(2)}</p>
            <button onClick={() => addToCart(product)}>Add to Cart</button>
          </div>
        ))}
      </div>

      {/* Shopping Cart - should be separate component */}
      <div className="shopping-cart">
        <h2>Shopping Cart ({cart.length} items)</h2>
        {cart.map(item => (
          <div key={item.id}>
            {item.name} x {item.quantity}
          </div>
        ))}
      </div>
    </div>
  );
};
```

**Problems with this approach:**
1. **7 responsibilities** in one component
2. **Hard to test** - must mock all dependencies
3. **Hard to reuse** - can't use cart logic without product display
4. **Hard to modify** - changes to filtering affect everything
5. **Large file** - difficult to navigate and understand

### ✅ Refactored - Applying SRP

Here's how to refactor the `ProductDashboard` into single-responsibility components and hooks:

#### 1. Data Fetching Hook (Single Responsibility: Data Fetching)

```typescript
// hooks/useProducts.ts
import { useState, useEffect } from 'react';
import type { Product } from '../types';
import { useProductData } from './useProductData';

export const useProducts = () => {
  // Single responsibility: Fetching and managing product data
  const { products, loading, error } = useProductData();
  
  return { products, loading, error };
};
```

#### 2. Filtering Hook (Single Responsibility: Filtering Logic)

```typescript
// hooks/useProductFilter.ts
import { useMemo } from 'react';
import type { Product } from '../types';

export const useProductFilter = (products: Product[], searchTerm: string) => {
  // Single responsibility: Filtering products based on search term
  return useMemo(() => {
    if (!searchTerm.trim()) {
      return products;
    }
    
    const lowerSearchTerm = searchTerm.toLowerCase();
    return products.filter(product =>
      product.name.toLowerCase().includes(lowerSearchTerm) ||
      product.description?.toLowerCase().includes(lowerSearchTerm)
    );
  }, [products, searchTerm]);
};
```

#### 3. Sorting Hook (Single Responsibility: Sorting Logic)

```typescript
// hooks/useProductSort.ts
import { useMemo } from 'react';
import type { Product, SortOption } from '../types';

export const useProductSort = (products: Product[], sortBy: SortOption) => {
  // Single responsibility: Sorting products
  return useMemo(() => {
    return [...products].sort((a, b) => {
      if (sortBy === 'name') {
        return a.name.localeCompare(b.name);
      }
      return a.price - b.price;
    });
  }, [products, sortBy]);
};
```

#### 4. Cart Hook (Single Responsibility: Cart Management)

```typescript
// hooks/useCart.ts
import { useState, useCallback, useMemo } from 'react';
import type { Product, CartItem } from '../types';

export const useCart = () => {
  // Single responsibility: Managing shopping cart state and operations
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

  const updateCartQuantity = useCallback((productId: number, quantity: number) => {
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

  const cartTotal = useMemo(() => {
    return cart.reduce((total, item) => total + item.price * item.quantity, 0);
  }, [cart]);

  const cartItemCount = useMemo(() => {
    return cart.reduce((count, item) => count + item.quantity, 0);
  }, [cart]);

  return {
    cart,
    addToCart,
    removeFromCart,
    updateCartQuantity,
    cartTotal,
    cartItemCount,
  };
};
```

#### 5. Search Input Component (Single Responsibility: Search Input UI)

```typescript
// components/SearchInput.tsx
import React from 'react';

interface SearchInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
}

export const SearchInput: React.FC<SearchInputProps> = ({
  value,
  onChange,
  placeholder = 'Search...',
}) => {
  // Single responsibility: Rendering search input UI
  return (
    <input
      type="text"
      value={value}
      onChange={(e) => onChange(e.target.value)}
      placeholder={placeholder}
      className="search-input"
    />
  );
};
```

#### 6. Sort Selector Component (Single Responsibility: Sort Selection UI)

```typescript
// components/SortSelector.tsx
import React from 'react';
import type { SortOption } from '../types';

interface SortSelectorProps {
  value: SortOption;
  onChange: (value: SortOption) => void;
}

export const SortSelector: React.FC<SortSelectorProps> = ({ value, onChange }) => {
  // Single responsibility: Rendering sort selector UI
  return (
    <select
      value={value}
      onChange={(e) => onChange(e.target.value as SortOption)}
      className="sort-select"
    >
      <option value="name">Sort by Name</option>
      <option value="price">Sort by Price</option>
    </select>
  );
};
```

#### 7. Product Card Component (Single Responsibility: Single Product Display)

```typescript
// components/ProductCard.tsx
import React from 'react';
import type { Product } from '../types';

interface ProductCardProps {
  product: Product;
  onAddToCart: (product: Product) => void;
}

export const ProductCard: React.FC<ProductCardProps> = ({ product, onAddToCart }) => {
  // Single responsibility: Displaying a single product
  return (
    <div className="product-card">
      <h3>{product.name}</h3>
      <p className="price">${product.price.toFixed(2)}</p>
      {product.description && (
        <p className="description">{product.description}</p>
      )}
      <button
        onClick={() => onAddToCart(product)}
        className="add-to-cart-btn"
      >
        Add to Cart
      </button>
    </div>
  );
};
```

#### 8. Product List Component (Single Responsibility: Product List Rendering)

```typescript
// components/ProductList.tsx
import React from 'react';
import type { Product } from '../types';
import { ProductCard } from './ProductCard';

interface ProductListProps {
  products: Product[];
  onAddToCart: (product: Product) => void;
}

export const ProductList: React.FC<ProductListProps> = ({ products, onAddToCart }) => {
  // Single responsibility: Rendering a list of products
  if (products.length === 0) {
    return <p>No products found</p>;
  }

  return (
    <div className="product-list">
      <h2>Products ({products.length})</h2>
      <div className="products-grid">
        {products.map(product => (
          <ProductCard
            key={product.id}
            product={product}
            onAddToCart={onAddToCart}
          />
        ))}
      </div>
    </div>
  );
};
```

#### 9. Cart Display Component (Single Responsibility: Cart Display)

```typescript
// components/CartDisplay.tsx
import React from 'react';
import type { CartItem } from '../types';

interface CartDisplayProps {
  cart: CartItem[];
  cartTotal: number;
  onRemoveItem: (productId: number) => void;
  onUpdateQuantity: (productId: number, quantity: number) => void;
}

export const CartDisplay: React.FC<CartDisplayProps> = ({
  cart,
  cartTotal,
  onRemoveItem,
  onUpdateQuantity,
}) => {
  // Single responsibility: Displaying shopping cart
  if (cart.length === 0) {
    return (
      <div className="shopping-cart">
        <h2>Shopping Cart</h2>
        <p>Your cart is empty</p>
      </div>
    );
  }

  return (
    <div className="shopping-cart">
      <h2>Shopping Cart ({cart.length} items)</h2>
      <div className="cart-items">
        {cart.map(item => (
          <div key={item.id} className="cart-item">
            <span>{item.name}</span>
            <span>${item.price.toFixed(2)}</span>
            <div className="quantity-controls">
              <button onClick={() => onUpdateQuantity(item.id, item.quantity - 1)}>
                -
              </button>
              <span>{item.quantity}</span>
              <button onClick={() => onUpdateQuantity(item.id, item.quantity + 1)}>
                +
              </button>
            </div>
            <span>${(item.price * item.quantity).toFixed(2)}</span>
            <button onClick={() => onRemoveItem(item.id)}>Remove</button>
          </div>
        ))}
      </div>
      <div className="cart-total">
        <strong>Total: ${cartTotal.toFixed(2)}</strong>
      </div>
    </div>
  );
};
```

#### 10. Loading Spinner Component (Single Responsibility: Loading State)

```typescript
// components/LoadingSpinner.tsx
import React from 'react';

export const LoadingSpinner: React.FC = () => {
  // Single responsibility: Displaying loading state
  return (
    <div className="loading-container">
      <p>Loading products...</p>
    </div>
  );
};
```

#### 11. Error Message Component (Single Responsibility: Error Display)

```typescript
// components/ErrorMessage.tsx
import React from 'react';

interface ErrorMessageProps {
  message: string;
}

export const ErrorMessage: React.FC<ErrorMessageProps> = ({ message }) => {
  // Single responsibility: Displaying error messages
  return (
    <div className="error-container">
      <h2>Error</h2>
      <p>{message}</p>
    </div>
  );
};
```

#### 12. Main Component (Single Responsibility: Composition/Orchestration)

```typescript
// components/ProductDashboard.tsx
import React, { useState } from 'react';
import { useProducts } from '../hooks/useProducts';
import { useProductFilter } from '../hooks/useProductFilter';
import { useProductSort } from '../hooks/useProductSort';
import { useCart } from '../hooks/useCart';
import { SearchInput } from './SearchInput';
import { SortSelector } from './SortSelector';
import { ProductList } from './ProductList';
import { CartDisplay } from './CartDisplay';
import { LoadingSpinner } from './LoadingSpinner';
import { ErrorMessage } from './ErrorMessage';
import type { SortOption } from '../types';

export const ProductDashboard: React.FC = () => {
  // Single responsibility: Orchestrating the product dashboard
  const [searchTerm, setSearchTerm] = useState('');
  const [sortBy, setSortBy] = useState<SortOption>('name');
  
  // Use focused hooks for each responsibility
  const { products, loading, error } = useProducts();
  const filteredProducts = useProductFilter(products, searchTerm);
  const sortedProducts = useProductSort(filteredProducts, sortBy);
  const { cart, addToCart, removeFromCart, updateCartQuantity, cartTotal } = useCart();

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error} />;

  return (
    <div className="product-dashboard">
      <h1>Product Dashboard</h1>
      
      <div className="controls">
        <SearchInput value={searchTerm} onChange={setSearchTerm} />
        <SortSelector value={sortBy} onChange={setSortBy} />
      </div>

      <ProductList products={sortedProducts} onAddToCart={addToCart} />
      
      <CartDisplay
        cart={cart}
        cartTotal={cartTotal}
        onRemoveItem={removeFromCart}
        onUpdateQuantity={updateCartQuantity}
      />
    </div>
  );
};
```

**Benefits of this refactored approach:**
1. ✅ **Each component/hook has one responsibility**
2. ✅ **Easy to test** - test each piece in isolation
3. ✅ **Easy to reuse** - use cart hook in different components
4. ✅ **Easy to modify** - change filtering without affecting cart
5. ✅ **Small, focused files** - easy to understand and navigate

## How to Apply SRP in React

### 1. Identify Component Responsibilities

**What it means**: Analyze your React component to understand all the different things it's doing.

**How to do it**:
- List all `useState` hooks - what state is being managed?
- List all `useEffect` hooks - what side effects are handled?
- List all event handlers - what user interactions are handled?
- List all rendering logic - what UI is being displayed?
- Ask: "What are all the different reasons this component might need to change?"

**Example**: In `ProductDashboard`, we identified:
- Data fetching (API calls)
- Filtering logic (search functionality)
- Sorting logic (ordering products)
- Cart management (adding/removing items)
- Error handling (displaying errors)
- Loading state (displaying loading)
- UI rendering (displaying products and cart)

### 2. Extract Custom Hooks

**What it means**: Move data fetching, state management, and business logic into custom hooks.

**How to do it**:
- Create a hook for each distinct concern
- Name hooks clearly (e.g., `useProducts`, `useCart`, `useProductFilter`)
- Return only what's needed from each hook
- Keep hooks focused on one responsibility

**Example**:
```typescript
// Before: Logic mixed in component
const [products, setProducts] = useState([]);
useEffect(() => { /* fetch logic */ }, []);

// After: Extracted to hook
const { products, loading, error } = useProducts();
```

### 3. Split Large Components

**What it means**: Break down large components into smaller, focused components.

**How to do it**:
- Identify distinct UI sections
- Create a component for each section
- Pass data via props
- Keep components small (ideally < 200 lines)

**Example**:
```typescript
// Before: One large component
<ProductDashboard /> // 500+ lines

// After: Multiple focused components
<SearchInput />
<SortSelector />
<ProductList />
<CartDisplay />
```

### 4. Separate Presentation from Logic

**What it means**: Keep components focused on rendering, move logic to hooks or services.

**How to do it**:
- Components should primarily render UI
- Business logic goes in hooks
- Data transformations go in utilities
- API calls go in services

**Example**:
```typescript
// Component: Only rendering
const ProductCard = ({ product, onAddToCart }) => (
  <div>
    <h3>{product.name}</h3>
    <button onClick={() => onAddToCart(product)}>Add to Cart</button>
  </div>
);

// Hook: Business logic
const useCart = () => {
  const [cart, setCart] = useState([]);
  const addToCart = (product) => { /* logic */ };
  return { cart, addToCart };
};
```

### 5. Use Composition

**What it means**: Build complex UIs by composing simple components.

**How to do it**:
- Create small, reusable components
- Compose them to build complex features
- Use props to customize behavior
- Avoid "God components" that do everything

## React-Specific SRP Guidelines

### Component Guidelines

- **One component, one purpose**: Each component should do one thing well
- **Keep components small**: Aim for < 200 lines per component
- **Focus on rendering**: Components should primarily handle UI
- **Use composition**: Build complex UIs from simple components

### Hook Guidelines

- **One hook, one concern**: Each hook should handle one specific concern
- **Separate data fetching**: Use hooks like `useProducts` for data
- **Separate state management**: Use hooks like `useCart` for state
- **Separate side effects**: Use hooks for specific side effects

### Service Guidelines

- **One service, one responsibility**: Each service should handle one type of operation
- **Separate API calls**: Don't mix product API with user API
- **Separate business logic**: Don't mix validation with formatting

## Testing with SRP

### Before (Hard to Test)

```typescript
// Hard to test - everything coupled
const ProductDashboard = () => {
  // Must mock fetch, state, effects, rendering
  // Complex test setup required
};
```

### After (Easy to Test)

```typescript
// Easy to test - separated concerns
test('useProducts fetches products', async () => {
  // Test hook in isolation
  const { result } = renderHook(() => useProducts());
  // Assert hook behavior
});

test('ProductCard renders product', () => {
  // Test component in isolation
  render(<ProductCard product={mockProduct} onAddToCart={jest.fn()} />);
  // Assert rendering
});
```

## Exercise: Refactor Mono-Component

### Objective

Refactor the `ProductDashboard` component in the reference application to follow the Single Responsibility Principle.

### Task

1. **Identify Responsibilities**: 
   - Open `frontend/reference-application/React/src/components/ProductDashboard.tsx`
   - List all the different responsibilities in the component
   - Document what each responsibility does

2. **Create Custom Hooks**:
   - Extract data fetching into `useProducts` hook
   - Extract filtering into `useProductFilter` hook
   - Extract sorting into `useProductSort` hook
   - Extract cart management into `useCart` hook

3. **Create Focused Components**:
   - Create `SearchInput` component
   - Create `SortSelector` component
   - Create `ProductCard` component
   - Create `ProductList` component
   - Create `CartDisplay` component
   - Create `LoadingSpinner` component
   - Create `ErrorMessage` component

4. **Refactor Main Component**:
   - Update `ProductDashboard` to use the new hooks and components
   - Keep it focused on orchestration only

5. **Update Tests**:
   - Update existing tests to work with new structure
   - Add tests for new components and hooks
   - Ensure all tests pass

### Deliverables

- List of responsibilities identified
- New component/hook structure
- Refactored code with all tests passing
- Brief explanation of improvements

### Success Criteria

- ✅ Each component/hook has a single, well-defined responsibility
- ✅ All existing tests pass
- ✅ New tests added for extracted components/hooks
- ✅ Code is more maintainable and readable
- ✅ Components can be reused independently

### Getting Started

1. Navigate to the reference application:
   ```bash
   cd frontend/reference-application/React
   ```

2. Install dependencies (if not already done):
   ```bash
   npm install
   ```

3. Run tests to see current state:
   ```bash
   npm test
   ```

4. Start refactoring one responsibility at a time

5. Run tests frequently to ensure nothing breaks

### Implementation Tips

- **Start small**: Extract one responsibility at a time
- **Test frequently**: Run tests after each extraction
- **Commit often**: Save your progress with meaningful commits
- **Keep it working**: Ensure functionality remains the same

---

**Next**: The [Open/Closed Principle](../2-Open-closed-principle/README.md) builds upon SRP by ensuring that our single-responsibility components can be extended without modification.
