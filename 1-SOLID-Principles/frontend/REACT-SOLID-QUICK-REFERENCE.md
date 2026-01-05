# React SOLID Principles - Quick Reference Guide

## Single Responsibility Principle (SRP)

### ❌ Violation: Mono-Component
```typescript
// Component does EVERYTHING
const ProductDashboard = () => {
  // Data fetching
  const [products, setProducts] = useState([]);
  useEffect(() => { /* fetch */ }, []);
  
  // Filtering
  const filtered = products.filter(/* ... */);
  
  // Sorting
  const sorted = filtered.sort(/* ... */);
  
  // Cart management
  const [cart, setCart] = useState([]);
  
  // Rendering
  return <div>{/* complex JSX */}</div>;
};
```

### ✅ Solution: Separate Responsibilities
```typescript
// 1. Data fetching hook
const useProducts = () => { /* ... */ };

// 2. Filtering hook
const useProductFilter = (products, term) => { /* ... */ };

// 3. Sorting hook
const useProductSort = (products, sortBy) => { /* ... */ };

// 4. Cart hook
const useCart = () => { /* ... */ };

// 5. UI components
const SearchInput = ({ value, onChange }) => { /* ... */ };
const ProductList = ({ products }) => { /* ... */ };

// 6. Orchestrator component
const ProductDashboard = () => {
  const { products } = useProducts();
  const filtered = useProductFilter(products, term);
  const sorted = useProductSort(filtered, sortBy);
  const { cart } = useCart();
  
  return (
    <>
      <SearchInput />
      <ProductList products={sorted} />
      <CartDisplay cart={cart} />
    </>
  );
};
```

**Key Points**:
- One component/hook = one responsibility
- Extract logic into custom hooks
- Split large components into smaller ones
- Use composition to combine responsibilities

---

## Open/Closed Principle (OCP)

### ❌ Violation: Hard-Coded Component
```typescript
// Cannot extend without modification
const Button = ({ text }) => {
  return (
    <button className="btn-primary" onClick={() => console.log('clicked')}>
      {text}
    </button>
  );
};
```

### ✅ Solution: Extensible via Props
```typescript
// Open for extension via props
interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'small' | 'medium' | 'large';
  onClick?: () => void;
  className?: string;
}

const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'medium',
  onClick,
  className = '',
}) => {
  return (
    <button
      className={`btn btn-${variant} btn-${size} ${className}`}
      onClick={onClick}
    >
      {children}
    </button>
  );
};

// Extended via composition (no modification needed)
const IconButton = ({ icon, children, ...props }) => (
  <Button {...props}>
    {icon}
    {children}
  </Button>
);
```

**Key Points**:
- Use props for customization
- Support composition via `children`
- Use render props for complex extension
- Avoid hard-coded values

---

## Liskov Substitution Principle (LSP)

### ❌ Violation: Breaking Contract
```typescript
// Base component
const Input = ({ value, onChange }) => (
  <input value={value} onChange={(e) => onChange(e.target.value)} />
);

// Violates LSP - changes behavior
const EmailInput = ({ value, onChange }) => {
  const handleChange = (e) => {
    const newValue = e.target.value.toLowerCase();
    // VIOLATION: Doesn't call onChange for invalid input
    if (!newValue.includes('@')) return;
    onChange(newValue);
  };
  return <input value={value} onChange={handleChange} type="email" />;
};
```

### ✅ Solution: Honor Contract
```typescript
// Base component
interface InputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
}

const Input: React.FC<InputProps> = ({ value, onChange, placeholder }) => (
  <input
    value={value}
    onChange={(e) => onChange(e.target.value)}
    placeholder={placeholder}
  />
);

// LSP-Compliant - maintains contract
const EmailInput: React.FC<InputProps> = ({ value, onChange, placeholder }) => {
  // Always calls onChange, maintains contract
  const handleChange = (e) => {
    onChange(e.target.value.toLowerCase());
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

**Key Points**:
- Extended components must honor base contract
- Props interfaces define contracts
- Always call callbacks as expected
- Maintain consistent behavior

---

## Interface Segregation Principle (ISP)

### ❌ Violation: Fat Props Interface
```typescript
// Component forced to accept unused props
interface UserProfileProps {
  // Display
  name: string;
  email: string;
  
  // Edit (not always needed)
  onEditName: (name: string) => void;
  onEditEmail: (email: string) => void;
  
  // Admin (rarely needed)
  isAdmin: boolean;
  adminActions: AdminAction[];
  
  // Analytics (not always needed)
  trackView: () => void;
}

const UserProfile: React.FC<UserProfileProps> = ({
  name,
  email,
  onEditName,
  onEditEmail,
  isAdmin,
  adminActions,
  trackView,
}) => {
  useEffect(() => {
    trackView(); // Forced to use
  }, [trackView]);
  
  return <div>{/* ... */}</div>;
};
```

### ✅ Solution: Segregated Interfaces
```typescript
// Focused interfaces
interface UserDisplayProps {
  name: string;
  email: string;
  avatar: string;
}

interface UserEditProps {
  name: string;
  email: string;
  onEditName: (name: string) => void;
  onEditEmail: (email: string) => void;
}

interface AdminPanelProps {
  isAdmin: boolean;
  adminActions: AdminAction[];
  onAdminAction: (action: AdminAction) => void;
}

// Focused components
const UserDisplay: React.FC<UserDisplayProps> = ({ name, email, avatar }) => (
  <div>
    <img src={avatar} alt={name} />
    <h2>{name}</h2>
    <p>{email}</p>
  </div>
);

const UserEdit: React.FC<UserEditProps> = ({ name, email, onEditName, onEditEmail }) => (
  <div>
    <UserDisplay name={name} email={email} avatar="" />
    <input value={name} onChange={(e) => onEditName(e.target.value)} />
    <input value={email} onChange={(e) => onEditEmail(e.target.value)} />
  </div>
);

const AdminPanel: React.FC<AdminPanelProps> = ({ isAdmin, adminActions, onAdminAction }) => {
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

// Compose as needed
const UserProfile = (props: UserDisplayProps & Partial<UserEditProps> & Partial<AdminPanelProps>) => (
  <div>
    <UserDisplay {...props} />
    {props.onEditName && <UserEdit {...props as UserEditProps} />}
    {props.isAdmin && <AdminPanel {...props as AdminPanelProps} />}
  </div>
);
```

**Key Points**:
- Minimal props - only what's needed
- Optional props for non-essential features
- Compose components instead of fat interfaces
- Create specialized components

---

## Dependency Inversion Principle (DIP)

### ❌ Violation: Direct Dependencies
```typescript
// Direct dependency on concrete implementation
const ProductList = () => {
  const [products, setProducts] = useState([]);
  
  useEffect(() => {
    // VIOLATION: Direct fetch dependency
    fetch('/api/products')
      .then(res => res.json())
      .then(data => setProducts(data));
  }, []);
  
  return <div>{/* ... */}</div>;
};
```

### ✅ Solution: Abstract Dependencies
```typescript
// 1. Define abstraction
interface ProductService {
  getProducts(): Promise<Product[]>;
}

// 2. Concrete implementation
class ApiProductService implements ProductService {
  async getProducts(): Promise<Product[]> {
    const response = await fetch('/api/products');
    return response.json();
  }
}

// 3. Mock for testing
class MockProductService implements ProductService {
  async getProducts(): Promise<Product[]> {
    return [{ id: 1, name: 'Test', price: 100 }];
  }
}

// 4. Hook depends on abstraction
const useProducts = (productService: ProductService) => {
  const [products, setProducts] = useState<Product[]>([]);
  
  useEffect(() => {
    productService.getProducts().then(setProducts);
  }, [productService]);
  
  return { products };
};

// 5. Component depends on abstraction
const ProductList: React.FC<{ productService: ProductService }> = ({ productService }) => {
  const { products } = useProducts(productService);
  return <div>{/* ... */}</div>;
};

// 6. Inject dependency
const App = () => {
  const productService = new ApiProductService(); // Or from context
  return <ProductList productService={productService} />;
};
```

**Key Points**:
- Define service interfaces
- Inject dependencies via props or context
- Use abstractions in hooks
- Easy to test with mocks

---

## React-Specific Patterns Summary

### Component Organization
```
components/
├── ProductDashboard.tsx    # Orchestrator (SRP)
├── ProductList.tsx          # Display (SRP)
├── ProductCard.tsx          # Single item (SRP)
├── SearchInput.tsx          # Input (SRP)
└── CartDisplay.tsx          # Cart (SRP)
```

### Hook Organization
```
hooks/
├── useProducts.ts           # Data fetching (SRP, DIP)
├── useProductFilter.ts      # Filtering (SRP)
├── useProductSort.ts        # Sorting (SRP)
└── useCart.ts              # Cart management (SRP)
```

### Service Organization
```
services/
├── ProductService.ts        # Interface (DIP)
├── ApiProductService.ts    # Implementation (DIP)
└── MockProductService.ts   # Test implementation (DIP)
```

### Type Organization
```
types/
└── index.ts                # All TypeScript interfaces
```

---

## Testing with SOLID

### Before (Hard to Test)
```typescript
// Hard to test - everything coupled
const ProductDashboard = () => {
  // Direct fetch, hard to mock
  useEffect(() => {
    fetch('/api/products').then(/* ... */);
  }, []);
  
  // Complex logic mixed with UI
  const filtered = products.filter(/* ... */);
  
  return <div>{/* complex JSX */}</div>;
};
```

### After (Easy to Test)
```typescript
// Easy to test - separated concerns
const useProducts = (productService: ProductService) => {
  // Can inject mock service
  const [products] = useState([]);
  useEffect(() => {
    productService.getProducts().then(/* ... */);
  }, [productService]);
  return { products };
};

// Test hook in isolation
test('useProducts fetches products', async () => {
  const mockService = { getProducts: jest.fn() };
  // Test hook...
});

// Test component in isolation
test('ProductList renders products', () => {
  const mockService = { getProducts: () => Promise.resolve([...]) };
  render(<ProductList productService={mockService} />);
  // Assert...
});
```

---

## Quick Checklist

When refactoring React code for SOLID:

- [ ] **SRP**: Each component/hook has one responsibility?
- [ ] **OCP**: Components extensible via props/composition?
- [ ] **LSP**: Extended components honor base contracts?
- [ ] **ISP**: Props interfaces minimal and focused?
- [ ] **DIP**: Dependencies abstracted and injectable?

---

## Common React Anti-Patterns to Avoid

1. **God Components**: Components that do everything
2. **Prop Drilling**: Passing many props through components
3. **Fat Interfaces**: Props with too many responsibilities
4. **Direct API Calls**: Fetch calls directly in components
5. **Hard-Coded Values**: No way to customize/extend
6. **Tight Coupling**: Components know too much about each other

---

## Resources

- **Summary**: `REACT-ADDITIONS-SUMMARY.md`
- **Implementation**: `reference-application/React/IMPLEMENTATION-CHECKLIST.md`
- **React App**: `reference-application/React/README.md`
- **Summary**: `REACT-ADDITIONS-SUMMARY.md`

