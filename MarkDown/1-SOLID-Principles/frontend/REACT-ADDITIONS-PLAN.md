# React.js SOLID Principles Additions - Implementation Plan

## Overview

This document outlines the plan to add React.js/TypeScript-specific content to the SOLID Principles course, making it directly applicable to front-end engineers building Single Page Applications (SPAs).

## Goals

1. **Make SOLID principles directly applicable** to React.js development
2. **Provide React-specific examples** for each principle
3. **Create a React reference application** that violates SOLID principles
4. **Add hands-on exercises** for refactoring React components
5. **Bridge the gap** between backend-focused examples and front-end development

---

## Content Structure

### 1. New Section: React.js Introduction

**Location**: `MarkDown/1-SOLID-Principles/0-README.md` (add new section)

**Content**:
- Introduction to SOLID principles in React context
- How React's component model relates to SOLID principles
- Overview of React reference application
- Prerequisites for React exercises

**Key Points**:
- React components as "classes" (functional components with hooks)
- Props as "interfaces"
- Hooks as "services"
- Composition over inheritance in React
- TypeScript interfaces for prop types

---

### 2. React Reference Application

**Location**: `MarkDown/1-SOLID-Principles/reference-application/React/`

**Application Overview**: E-commerce Product Management Dashboard

**Features** (intentionally violating SOLID):
- Product listing with search, filtering, sorting
- Shopping cart management
- User authentication UI
- Order history display
- Product detail view with reviews
- Admin panel for product management

**Technology Stack**:
- React 18+ with TypeScript
- React Router for navigation
- React Query (or similar) for data fetching
- CSS Modules or styled-components
- Jest + React Testing Library for tests

**Structure**:
```
React/
├── package.json
├── tsconfig.json
├── vite.config.ts (or similar build tool)
├── README.md
├── src/
│   ├── App.tsx (main app - violates multiple principles)
│   ├── components/
│   │   └── ProductDashboard.tsx (mono-component violating SRP)
│   ├── hooks/
│   │   └── useProductData.ts (violates SRP, DIP)
│   ├── services/
│   │   └── api.ts (violates DIP)
│   ├── types/
│   │   └── index.ts
│   └── utils/
│       └── helpers.ts
├── tests/
│   ├── App.test.tsx
│   └── components/
│       └── ProductDashboard.test.tsx
└── build-and-test.sh
```

---

### 3. Principle-Specific React Additions

#### 3.1 Single Responsibility Principle - React Edition

**Location**: `MarkDown/1-SOLID-Principles/1-Single-class-reponsibility-principle/README-REACT.md`

**New Content Sections**:

##### A. React Component Responsibilities
- **What it means**: Each component should have a single, well-defined purpose
- **Common violations**: 
  - Components that handle data fetching, state management, rendering, and business logic
  - "God components" that do everything
  - Components mixing presentation and business logic

##### B. React-Specific Examples

**Violating SRP - Mono-Component Example**:
```typescript
// ProductDashboard.tsx - VIOLATES SRP
// This component handles: data fetching, filtering, sorting, rendering, cart management
export const ProductDashboard: React.FC = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [filteredProducts, setFilteredProducts] = useState<Product[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [sortBy, setSortBy] = useState<'name' | 'price'>('name');
  const [cart, setCart] = useState<CartItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Responsibility 1: Data Fetching
  useEffect(() => {
    const fetchProducts = async () => {
      setLoading(true);
      try {
        const response = await fetch('/api/products');
        const data = await response.json();
        setProducts(data);
      } catch (err) {
        setError('Failed to fetch products');
      } finally {
        setLoading(false);
      }
    };
    fetchProducts();
  }, []);

  // Responsibility 2: Filtering Logic
  useEffect(() => {
    const filtered = products.filter(product => 
      product.name.toLowerCase().includes(searchTerm.toLowerCase())
    );
    setFilteredProducts(filtered);
  }, [products, searchTerm]);

  // Responsibility 3: Sorting Logic
  const sortedProducts = useMemo(() => {
    return [...filteredProducts].sort((a, b) => {
      if (sortBy === 'name') return a.name.localeCompare(b.name);
      return a.price - b.price;
    });
  }, [filteredProducts, sortBy]);

  // Responsibility 4: Cart Management
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
      return [...prev, { ...product, quantity: 1 }];
    });
  };

  // Responsibility 5: Rendering
  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div>
      <input
        type="text"
        value={searchTerm}
        onChange={(e) => setSearchTerm(e.target.value)}
        placeholder="Search products..."
      />
      <select value={sortBy} onChange={(e) => setSortBy(e.target.value as 'name' | 'price')}>
        <option value="name">Sort by Name</option>
        <option value="price">Sort by Price</option>
      </select>
      <div>
        {sortedProducts.map(product => (
          <div key={product.id}>
            <h3>{product.name}</h3>
            <p>${product.price}</p>
            <button onClick={() => addToCart(product)}>Add to Cart</button>
          </div>
        ))}
      </div>
      <div>
        <h3>Cart ({cart.length} items)</h3>
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

**Refactored - Applying SRP**:
```typescript
// 1. Data Fetching Hook (Single Responsibility: Data Fetching)
const useProducts = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchProducts = async () => {
      setLoading(true);
      try {
        const response = await fetch('/api/products');
        const data = await response.json();
        setProducts(data);
      } catch (err) {
        setError('Failed to fetch products');
      } finally {
        setLoading(false);
      }
    };
    fetchProducts();
  }, []);

  return { products, loading, error };
};

// 2. Filtering Hook (Single Responsibility: Filtering Logic)
const useProductFilter = (products: Product[], searchTerm: string) => {
  return useMemo(() => {
    return products.filter(product =>
      product.name.toLowerCase().includes(searchTerm.toLowerCase())
    );
  }, [products, searchTerm]);
};

// 3. Sorting Hook (Single Responsibility: Sorting Logic)
const useProductSort = (products: Product[], sortBy: 'name' | 'price') => {
  return useMemo(() => {
    return [...products].sort((a, b) => {
      if (sortBy === 'name') return a.name.localeCompare(b.name);
      return a.price - b.price;
    });
  }, [products, sortBy]);
};

// 4. Cart Hook (Single Responsibility: Cart Management)
const useCart = () => {
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
      return [...prev, { ...product, quantity: 1 }];
    });
  }, []);

  return { cart, addToCart };
};

// 5. Search Input Component (Single Responsibility: Search Input UI)
const SearchInput: React.FC<{ value: string; onChange: (value: string) => void }> = ({
  value,
  onChange,
}) => (
  <input
    type="text"
    value={value}
    onChange={(e) => onChange(e.target.value)}
    placeholder="Search products..."
  />
);

// 6. Sort Selector Component (Single Responsibility: Sort Selection UI)
const SortSelector: React.FC<{
  value: 'name' | 'price';
  onChange: (value: 'name' | 'price') => void;
}> = ({ value, onChange }) => (
  <select value={value} onChange={(e) => onChange(e.target.value as 'name' | 'price')}>
    <option value="name">Sort by Name</option>
    <option value="price">Sort by Price</option>
  </select>
);

// 7. Product List Component (Single Responsibility: Product List Rendering)
const ProductList: React.FC<{
  products: Product[];
  onAddToCart: (product: Product) => void;
}> = ({ products, onAddToCart }) => (
  <div>
    {products.map(product => (
      <ProductCard key={product.id} product={product} onAddToCart={onAddToCart} />
    ))}
  </div>
);

// 8. Product Card Component (Single Responsibility: Single Product Display)
const ProductCard: React.FC<{
  product: Product;
  onAddToCart: (product: Product) => void;
}> = ({ product, onAddToCart }) => (
  <div>
    <h3>{product.name}</h3>
    <p>${product.price}</p>
    <button onClick={() => onAddToCart(product)}>Add to Cart</button>
  </div>
);

// 9. Cart Display Component (Single Responsibility: Cart Display)
const CartDisplay: React.FC<{ cart: CartItem[] }> = ({ cart }) => (
  <div>
    <h3>Cart ({cart.length} items)</h3>
    {cart.map(item => (
      <div key={item.id}>
        {item.name} x {item.quantity}
      </div>
    ))}
  </div>
);

// 10. Main Component (Single Responsibility: Composition/Orchestration)
export const ProductDashboard: React.FC = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [sortBy, setSortBy] = useState<'name' | 'price'>('name');
  
  const { products, loading, error } = useProducts();
  const filteredProducts = useProductFilter(products, searchTerm);
  const sortedProducts = useProductSort(filteredProducts, sortBy);
  const { cart, addToCart } = useCart();

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error} />;

  return (
    <div>
      <SearchInput value={searchTerm} onChange={setSearchTerm} />
      <SortSelector value={sortBy} onChange={setSortBy} />
      <ProductList products={sortedProducts} onAddToCart={addToCart} />
      <CartDisplay cart={cart} />
    </div>
  );
};
```

##### C. React-Specific SRP Guidelines
- **One component, one purpose**: Each component should do one thing well
- **Separate data fetching from rendering**: Use custom hooks for data logic
- **Separate business logic from UI**: Extract logic into hooks or services
- **Separate concerns**: Split large components into smaller, focused ones
- **Composition over complexity**: Build complex UIs from simple components

##### D. Exercise: Refactor Mono-Component
- **Task**: Refactor `ProductDashboard.tsx` into single-responsibility components
- **Deliverables**: 
  - List of responsibilities identified
  - New component/hook structure
  - Refactored code with tests passing

---

#### 3.2 Open/Closed Principle - React Edition

**Location**: `MarkDown/1-SOLID-Principles/2-Open-closed-principle/README-REACT.md`

**New Content Sections**:

##### A. React Component Extensibility
- **What it means**: Components should be open for extension (via props/composition) but closed for modification
- **React patterns**: 
  - Component composition
  - Render props
  - Higher-order components (HOCs)
  - Compound components
  - Children prop patterns

##### B. React-Specific Examples

**Violating OCP - Hard-coded Component**:
```typescript
// Button.tsx - VIOLATES OCP
// Must modify component to add new button variants
export const Button: React.FC<{ text: string }> = ({ text }) => {
  return (
    <button className="btn-primary" onClick={() => console.log('Clicked')}>
      {text}
    </button>
  );
};
```

**Refactored - Applying OCP**:
```typescript
// Button.tsx - Open for extension via props
interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'small' | 'medium' | 'large';
  onClick?: () => void;
  className?: string;
}

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'medium',
  onClick,
  className = '',
}) => {
  const baseClasses = 'btn';
  const variantClass = `btn-${variant}`;
  const sizeClass = `btn-${size}`;
  
  return (
    <button
      className={`${baseClasses} ${variantClass} ${sizeClass} ${className}`}
      onClick={onClick}
    >
      {children}
    </button>
  );
};

// Extended via composition (no modification needed)
export const IconButton: React.FC<ButtonProps & { icon: React.ReactNode }> = ({
  icon,
  children,
  ...buttonProps
}) => (
  <Button {...buttonProps}>
    {icon}
    {children}
  </Button>
);
```

##### C. React Composition Patterns
- **Children prop**: Extend components via children
- **Render props**: Extend behavior via function props
- **Compound components**: Extend via component composition
- **HOCs**: Extend via higher-order component wrapping

##### D. Exercise: Make Components Extensible
- **Task**: Refactor hard-coded components to be extensible via props/composition
- **Deliverables**: Extensible component implementations

---

#### 3.3 Liskov Substitution Principle - React Edition

**Location**: `MarkDown/1-SOLID-Principles/3-Liskov-substitution-principle/README-REACT.md`

**New Content Sections**:

##### A. React Component Substitutability
- **What it means**: Components that extend or implement interfaces should be substitutable without breaking functionality
- **React context**: 
  - Component props interfaces
  - Polymorphic components
  - Component inheritance (when used)
  - Interface implementations

##### B. React-Specific Examples

**Violating LSP - Inconsistent Component Behavior**:
```typescript
// Base Input Component
interface InputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
}

export const Input: React.FC<InputProps> = ({ value, onChange, placeholder }) => (
  <input
    value={value}
    onChange={(e) => onChange(e.target.value)}
    placeholder={placeholder}
  />
);

// Violating LSP - EmailInput changes expected behavior
export const EmailInput: React.FC<InputProps> = ({ value, onChange }) => {
  // VIOLATION: Doesn't call onChange with the same signature
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value.toLowerCase(); // Modifies behavior
    if (!newValue.includes('@')) {
      // VIOLATION: Doesn't call onChange for invalid input
      return;
    }
    onChange(newValue);
  };

  return <input value={value} onChange={handleChange} type="email" />;
};
```

**Refactored - Applying LSP**:
```typescript
// Base Input Component
interface InputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
}

export const Input: React.FC<InputProps> = ({ value, onChange, placeholder }) => (
  <input
    value={value}
    onChange={(e) => onChange(e.target.value)}
    placeholder={placeholder}
  />
);

// LSP-Compliant - EmailInput maintains contract
export const EmailInput: React.FC<InputProps> = ({ value, onChange, placeholder }) => {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value.toLowerCase();
    // Always calls onChange, maintains contract
    onChange(newValue);
  };

  return (
    <input
      value={value}
      onChange={handleChange}
      type="email"
      placeholder={placeholder}
    />
  );
};
```

##### C. React Component Contracts
- **Props interfaces as contracts**: Components should honor prop contracts
- **Polymorphic components**: Components that can be used interchangeably
- **Consistent behavior**: Extended components should behave consistently

##### D. Exercise: Fix Component Substitutability
- **Task**: Refactor components to be properly substitutable
- **Deliverables**: LSP-compliant component implementations

---

#### 3.4 Interface Segregation Principle - React Edition

**Location**: `MarkDown/1-SOLID-Principles/4-Interface-segregation-principle/README-REACT.md`

**New Content Sections**:

##### A. React Props Interface Design
- **What it means**: Components should not be forced to depend on props they don't use
- **React context**: 
  - Fat prop interfaces
  - Optional vs required props
  - Prop splitting
  - Component specialization

##### B. React-Specific Examples

**Violating ISP - Fat Props Interface**:
```typescript
// UserProfile.tsx - VIOLATES ISP
// Component forced to accept props it doesn't use
interface UserProfileProps {
  // Display props
  name: string;
  email: string;
  avatar: string;
  
  // Edit props (not always needed)
  onEditName: (name: string) => void;
  onEditEmail: (email: string) => void;
  onEditAvatar: (avatar: string) => void;
  
  // Admin props (rarely needed)
  isAdmin: boolean;
  adminActions: AdminAction[];
  onAdminAction: (action: AdminAction) => void;
  
  // Analytics props (not always needed)
  trackView: () => void;
  trackInteraction: (event: string) => void;
}

export const UserProfile: React.FC<UserProfileProps> = ({
  name,
  email,
  avatar,
  onEditName,
  onEditEmail,
  onEditAvatar,
  isAdmin,
  adminActions,
  onAdminAction,
  trackView,
  trackInteraction,
}) => {
  useEffect(() => {
    trackView(); // Forced to use analytics
  }, [trackView]);

  return (
    <div>
      <img src={avatar} alt={name} />
      <h2>{name}</h2>
      <p>{email}</p>
      {/* Component must handle all these cases */}
    </div>
  );
};
```

**Refactored - Applying ISP**:
```typescript
// Segregated interfaces
interface UserDisplayProps {
  name: string;
  email: string;
  avatar: string;
}

interface UserEditProps {
  name: string;
  email: string;
  avatar: string;
  onEditName: (name: string) => void;
  onEditEmail: (email: string) => void;
  onEditAvatar: (avatar: string) => void;
}

interface AdminPanelProps {
  isAdmin: boolean;
  adminActions: AdminAction[];
  onAdminAction: (action: AdminAction) => void;
}

// Focused components
export const UserDisplay: React.FC<UserDisplayProps> = ({ name, email, avatar }) => (
  <div>
    <img src={avatar} alt={name} />
    <h2>{name}</h2>
    <p>{email}</p>
  </div>
);

export const UserEdit: React.FC<UserEditProps> = ({
  name,
  email,
  avatar,
  onEditName,
  onEditEmail,
  onEditAvatar,
}) => (
  <div>
    <UserDisplay name={name} email={email} avatar={avatar} />
    <input value={name} onChange={(e) => onEditName(e.target.value)} />
    <input value={email} onChange={(e) => onEditEmail(e.target.value)} />
    <input value={avatar} onChange={(e) => onEditAvatar(e.target.value)} />
  </div>
);

export const AdminPanel: React.FC<AdminPanelProps> = ({
  isAdmin,
  adminActions,
  onAdminAction,
}) => {
  if (!isAdmin) return null;
  
  return (
    <div>
      {adminActions.map(action => (
        <button key={action.id} onClick={() => onAdminAction(action)}>
          {action.label}
        </button>
      ))}
    </div>
  );
};

// Composition for complex cases
export const UserProfile: React.FC<UserDisplayProps & Partial<UserEditProps> & Partial<AdminPanelProps>> = (props) => (
  <div>
    <UserDisplay name={props.name} email={props.email} avatar={props.avatar} />
    {props.onEditName && <UserEdit {...props as UserEditProps} />}
    {props.isAdmin && <AdminPanel {...props as AdminPanelProps} />}
  </div>
);
```

##### C. React Props Best Practices
- **Minimal props**: Only include what's needed
- **Optional props**: Use optional props for non-essential features
- **Composition**: Compose components instead of fat interfaces
- **Specialization**: Create specialized components for specific use cases

##### D. Exercise: Segregate Fat Props Interfaces
- **Task**: Refactor components with fat prop interfaces into focused components
- **Deliverables**: Segregated component interfaces and implementations

---

#### 3.5 Dependency Inversion Principle - React Edition

**Location**: `MarkDown/1-SOLID-Principles/5-Dependency-segregation-principle/README-REACT.md`

**New Content Sections**:

##### A. React Dependency Management
- **What it means**: Components should depend on abstractions (interfaces/types) not concrete implementations
- **React context**: 
  - API service abstractions
  - Hook abstractions
  - Context providers
  - Dependency injection in React

##### B. React-Specific Examples

**Violating DIP - Direct Dependencies**:
```typescript
// ProductList.tsx - VIOLATES DIP
// Directly depends on concrete API implementation
export const ProductList: React.FC = () => {
  const [products, setProducts] = useState<Product[]>([]);

  useEffect(() => {
    // VIOLATION: Direct dependency on fetch API
    fetch('/api/products')
      .then(res => res.json())
      .then(data => setProducts(data));
  }, []);

  return (
    <div>
      {products.map(product => (
        <div key={product.id}>{product.name}</div>
      ))}
    </div>
  );
};
```

**Refactored - Applying DIP**:
```typescript
// Abstraction (interface)
interface ProductService {
  getProducts(): Promise<Product[]>;
}

// Concrete implementation
class ApiProductService implements ProductService {
  async getProducts(): Promise<Product[]> {
    const response = await fetch('/api/products');
    return response.json();
  }
}

// Mock implementation for testing
class MockProductService implements ProductService {
  async getProducts(): Promise<Product[]> {
    return [
      { id: 1, name: 'Test Product', price: 100 },
    ];
  }
}

// Hook depends on abstraction
const useProducts = (productService: ProductService) => {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setLoading(true);
    productService.getProducts()
      .then(data => {
        setProducts(data);
        setLoading(false);
      });
  }, [productService]);

  return { products, loading };
};

// Component depends on abstraction
export const ProductList: React.FC<{ productService: ProductService }> = ({ productService }) => {
  const { products, loading } = useProducts(productService);

  if (loading) return <div>Loading...</div>;

  return (
    <div>
      {products.map(product => (
        <div key={product.id}>{product.name}</div>
      ))}
    </div>
  );
};

// Usage with dependency injection
export const App: React.FC = () => {
  const productService = new ApiProductService(); // Or from context/provider
  
  return <ProductList productService={productService} />;
};
```

##### C. React Dependency Injection Patterns
- **Props injection**: Pass dependencies via props
- **Context providers**: Use React Context for dependency injection
- **Custom hooks**: Abstract dependencies in hooks
- **Service locator**: Use service locator pattern (less common in React)

##### D. Exercise: Implement Dependency Inversion
- **Task**: Refactor components to depend on abstractions
- **Deliverables**: Abstracted services and dependency-injected components

---

## Implementation Plan

### Phase 1: Foundation (Week 1-2)
1. ✅ Create this plan document
2. Create React reference application structure
3. Implement violating components for each principle
4. Write initial tests
5. Create build and test scripts

### Phase 2: Content Creation (Week 3-4)
1. Write React-specific README for each principle
2. Create React code examples
3. Write React-specific exercises
4. Create solution guides

### Phase 3: Integration (Week 5)
1. Update main README with React section
2. Link React content from principle pages
3. Update course workflow document
4. Create React-specific learning path

### Phase 4: Testing & Refinement (Week 6)
1. Test all exercises
2. Review code examples
3. Get feedback from React developers
4. Refine based on feedback

---

## File Structure

```
MarkDown/1-SOLID-Principles/
├── 0-README.md (update with React section)
├── 1-Single-class-reponsibility-principle/
│   ├── README.md (existing)
│   └── README-REACT.md (new)
├── 2-Open-closed-principle/
│   ├── README.md (existing)
│   └── README-REACT.md (new)
├── 3-Liskov-substitution-principle/
│   ├── README.md (existing)
│   └── README-REACT.md (new)
├── 4-Interface-segregation-principle/
│   ├── README.md (existing)
│   └── README-REACT.md (new)
├── 5-Dependency-segregation-principle/
│   ├── README.md (existing)
│   └── README-REACT.md (new)
├── reference-application/
│   ├── React/ (new)
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   ├── vite.config.ts
│   │   ├── README.md
│   │   ├── build-and-test.sh
│   │   ├── src/
│   │   │   ├── App.tsx
│   │   │   ├── components/
│   │   │   │   ├── ProductDashboard.tsx (violates SRP)
│   │   │   │   ├── UserProfile.tsx (violates ISP)
│   │   │   │   └── ...
│   │   │   ├── hooks/
│   │   │   │   └── useProductData.ts (violates DIP)
│   │   │   ├── services/
│   │   │   │   └── api.ts (violates DIP)
│   │   │   └── types/
│   │   │       └── index.ts
│   │   └── tests/
│   │       └── ...
│   └── ... (existing languages)
└── REACT-ADDITIONS-PLAN.md (this file)
```

---

## React Reference Application Details

### Application: E-commerce Product Management Dashboard

#### Features (Violating SOLID):

1. **ProductDashboard Component** (Violates SRP)
   - Fetches products
   - Filters products
   - Sorts products
   - Manages cart
   - Renders UI
   - Handles errors
   - Manages loading state

2. **UserProfile Component** (Violates ISP)
   - Display props
   - Edit props
   - Admin props
   - Analytics props
   - All in one interface

3. **ProductList Component** (Violates OCP)
   - Hard-coded styling
   - Hard-coded behavior
   - Cannot be extended without modification

4. **Input Components** (Violates LSP)
   - EmailInput changes expected behavior
   - NumberInput doesn't honor base contract

5. **Data Fetching** (Violates DIP)
   - Direct fetch() calls
   - Hard-coded API endpoints
   - No abstraction layer

### Technology Choices:
- **React 18+**: Latest React features
- **TypeScript**: Type safety
- **Vite**: Fast build tool
- **React Router**: Navigation
- **React Query**: Data fetching (optional)
- **Jest + React Testing Library**: Testing
- **CSS Modules**: Styling (or styled-components)

---

## Exercise Structure

Each principle will have:

1. **Theory Section**: React-specific explanation
2. **Violation Example**: Real React code violating the principle
3. **Refactored Example**: SOLID-compliant React code
4. **Exercise**: Hands-on refactoring task
5. **Solution Guide**: Step-by-step solution (separate file)

---

## Success Metrics

- ✅ React developers can apply SOLID principles to their code
- ✅ Clear React-specific examples for each principle
- ✅ Working reference application with violations
- ✅ Practical exercises that build real skills
- ✅ All tests pass after refactoring
- ✅ Code is maintainable and extensible

---

## Next Steps

1. Review and approve this plan
2. Create React reference application
3. Write React-specific content for each principle
4. Create exercises and solution guides
5. Test with React developers
6. Integrate into main course

---

## Notes

- Keep React examples practical and realistic
- Focus on common React patterns and anti-patterns
- Ensure examples are immediately applicable
- Balance theory with hands-on practice
- Make exercises progressive (build on each other)

