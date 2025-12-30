# Open/Closed Principle (OCP) - React Edition

## Name
**Open/Closed Principle** - The "O" in SOLID

## Goal of the Principle

In React, the Open/Closed Principle means: **Components should be open for extension but closed for modification**. You should be able to add new functionality or customize behavior without changing the component's source code.

## React-Specific Application

### What It Means in React

In React development, OCP applies to:

- **Component Extensibility**: Components should be extensible via props and composition
- **Props Interfaces**: Using TypeScript interfaces to allow customization
- **Composition Patterns**: Using children, render props, and HOCs for extension
- **Behavior Customization**: Allowing behavior changes without code modification

### React Component Extensibility

A React component should be:
- **Open for extension**: Can be extended via props, children, or composition
- **Closed for modification**: Source code doesn't need to change for new use cases

**The Problem**: When components are hard-coded, you must modify the source code to:
- Add new variants or styles
- Change behavior
- Add new features
- Customize appearance

## Theoretical Foundation

### Bertrand Meyer's Original Formulation

The Open/Closed Principle was first articulated by Bertrand Meyer in 1988. In React, this translates to designing components that can be extended through:
- **Props**: Configuration via props
- **Composition**: Building on top of components
- **Children**: Extending via children prop
- **Render Props**: Extending behavior via function props

### Information Hiding and Encapsulation

OCP in React relies on:
- **Props as Interface**: Props define what can be customized
- **Encapsulation**: Internal implementation is hidden
- **Stable Interfaces**: Props interface remains stable while implementation can change

### Polymorphism in React

React components achieve extensibility through:
- **Props Polymorphism**: Different props produce different behavior
- **Composition Polymorphism**: Different compositions produce different UIs
- **Render Props**: Function props allow behavior customization

## Consequences of Violating OCP in React

### React-Specific Issues

**Modification Risk and Regression**
- Every modification to existing components risks breaking functionality
- Changes require retesting all use cases
- New features require changing tested code

**Hard-Coded Limitations**
- Cannot add new button variants without modifying source
- Cannot change styling without modifying component
- Cannot extend behavior without code changes

**Testing Overhead**
- Must retest component after every modification
- Cannot test extensions independently
- Integration testing becomes more complex

**Reduced Reusability**
- Components can't be reused in different contexts
- Must duplicate code for similar but different needs
- Forces creation of new components for slight variations

## React-Specific Examples

### ❌ Violating OCP - Hard-Coded Component

The `Button` component in our reference application violates OCP:

**Location**: `frontend/reference-application/React/src/components/Button.tsx`

```typescript
// Button.tsx - VIOLATES OCP
// Must modify component to add new button variants
interface ButtonProps {
  text: string;
}

export const Button: React.FC<ButtonProps> = ({ text }) => {
  // VIOLATION: Hard-coded styling
  // VIOLATION: Hard-coded behavior
  // VIOLATION: Cannot be extended without modification
  return (
    <button
      className="btn-primary"
      onClick={() => {
        console.log('Button clicked');
        // Hard-coded behavior
      }}
      style={{
        padding: '10px 20px',
        backgroundColor: '#007bff',
        color: 'white',
        border: 'none',
        borderRadius: '4px',
        cursor: 'pointer',
      }}
    >
      {text}
    </button>
  );
};

// VIOLATION: To add a secondary button, must modify this component
// VIOLATION: To add different sizes, must modify this component
// VIOLATION: To add icons, must modify this component
// VIOLATION: To add custom onClick, must modify this component
```

**Problems:**
- ❌ Cannot add new variants without modifying source
- ❌ Cannot customize styling without changing code
- ❌ Cannot change behavior without modification
- ❌ Hard-coded onClick handler

### ✅ Refactored - Applying OCP

Here's how to make the Button component extensible:

```typescript
// Button.tsx - Open for extension via props
import React from 'react';

export type ButtonVariant = 'primary' | 'secondary' | 'danger' | 'success' | 'warning';
export type ButtonSize = 'small' | 'medium' | 'large';

interface ButtonProps {
  children: React.ReactNode;
  variant?: ButtonVariant;
  size?: ButtonSize;
  onClick?: () => void;
  disabled?: boolean;
  type?: 'button' | 'submit' | 'reset';
  className?: string;
  fullWidth?: boolean;
}

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'medium',
  onClick,
  disabled = false,
  type = 'button',
  className = '',
  fullWidth = false,
}) => {
  // Extensible via props - no modification needed for new variants
  const baseClasses = 'btn';
  const variantClass = `btn-${variant}`;
  const sizeClass = `btn-${size}`;
  const widthClass = fullWidth ? 'btn-full-width' : '';
  
  return (
    <button
      type={type}
      className={`${baseClasses} ${variantClass} ${sizeClass} ${widthClass} ${className}`}
      onClick={onClick}
      disabled={disabled}
    >
      {children}
    </button>
  );
};

// Extended via composition (no modification needed)
export const IconButton: React.FC<ButtonProps & { icon: React.ReactNode; iconPosition?: 'left' | 'right' }> = ({
  icon,
  iconPosition = 'left',
  children,
  ...buttonProps
}) => (
  <Button {...buttonProps}>
    {iconPosition === 'left' && <span className="icon">{icon}</span>}
    {children}
    {iconPosition === 'right' && <span className="icon">{icon}</span>}
  </Button>
);

// Extended via composition (no modification needed)
export const LoadingButton: React.FC<ButtonProps & { loading?: boolean }> = ({
  loading,
  children,
  disabled,
  ...buttonProps
}) => (
  <Button {...buttonProps} disabled={disabled || loading}>
    {loading ? (
      <>
        <span className="spinner" /> Loading...
      </>
    ) : (
      children
    )}
  </Button>
);
```

**Benefits:**
- ✅ Can add new variants via props (no code change)
- ✅ Can customize styling via className prop
- ✅ Can change behavior via onClick prop
- ✅ Can extend via composition (IconButton, LoadingButton)

### ❌ Violating OCP - Hard-Coded Product List

The `ProductList` component also violates OCP:

**Location**: `frontend/reference-application/React/src/components/ProductList.tsx`

```typescript
// ProductList.tsx - VIOLATES OCP
// Hard-coded layout and styling - cannot be extended
interface ProductListProps {
  products: Product[];
}

export const ProductList: React.FC<ProductListProps> = ({ products }) => {
  // VIOLATION: Hard-coded grid layout
  // VIOLATION: Hard-coded styling
  // VIOLATION: Cannot be extended without modification
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(3, 1fr)',
        gap: '20px',
        padding: '20px',
      }}
    >
      {products.map(product => (
        <div
          key={product.id}
          style={{
            border: '1px solid #ccc',
            borderRadius: '8px',
            padding: '15px',
            backgroundColor: '#fff',
          }}
        >
          <h3 style={{ marginTop: 0 }}>{product.name}</h3>
          <p style={{ fontSize: '18px', fontWeight: 'bold', color: '#007bff' }}>
            ${product.price.toFixed(2)}
          </p>
        </div>
      ))}
    </div>
  );
};
```

### ✅ Refactored - Applying OCP

```typescript
// ProductList.tsx - Open for extension
import React from 'react';
import type { Product } from '../types';

export type ProductListLayout = 'grid' | 'list' | 'compact';

interface ProductListProps {
  products: Product[];
  layout?: ProductListLayout;
  renderProduct?: (product: Product) => React.ReactNode;
  className?: string;
  emptyMessage?: string;
}

export const ProductList: React.FC<ProductListProps> = ({
  products,
  layout = 'grid',
  renderProduct,
  className = '',
  emptyMessage = 'No products found',
}) => {
  if (products.length === 0) {
    return <p className="empty-message">{emptyMessage}</p>;
  }

  // Extensible layout via props
  const layoutClass = `product-list-${layout}`;
  
  // Extensible rendering via render prop
  if (renderProduct) {
    return (
      <div className={`product-list ${layoutClass} ${className}`}>
        {products.map(product => (
          <div key={product.id}>
            {renderProduct(product)}
          </div>
        ))}
      </div>
    );
  }

  // Default rendering
  return (
    <div className={`product-list ${layoutClass} ${className}`}>
      {products.map(product => (
        <div key={product.id} className="product-item">
          <h3>{product.name}</h3>
          <p className="price">${product.price.toFixed(2)}</p>
        </div>
      ))}
    </div>
  );
};

// Extended via render prop (no modification needed)
export const ProductListWithActions: React.FC<ProductListProps & {
  onAddToCart: (product: Product) => void;
}> = ({ products, onAddToCart, ...props }) => (
  <ProductList
    {...props}
    products={products}
    renderProduct={(product) => (
      <div className="product-card">
        <h3>{product.name}</h3>
        <p>${product.price.toFixed(2)}</p>
        <button onClick={() => onAddToCart(product)}>Add to Cart</button>
      </div>
    )}
  />
);
```

## React Composition Patterns for OCP

### 1. Props-Based Extension

**What it means**: Extend components via props without modifying source.

**Example**:
```typescript
// Base component - extensible via props
<Button variant="secondary" size="large" onClick={handleClick}>
  Click Me
</Button>

// New variant - no code change needed
<Button variant="danger" size="small">
  Delete
</Button>
```

### 2. Children Prop Pattern

**What it means**: Extend components via children without modifying source.

**Example**:
```typescript
// Base component
const Card: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <div className="card">{children}</div>
);

// Extended via children - no modification needed
<Card>
  <h2>Title</h2>
  <p>Content</p>
  <Button>Action</Button>
</Card>
```

### 3. Render Props Pattern

**What it means**: Extend behavior via function props.

**Example**:
```typescript
// Base component with render prop
interface DataFetcherProps<T> {
  url: string;
  render: (data: T | null, loading: boolean, error: Error | null) => React.ReactNode;
}

const DataFetcher = <T,>({ url, render }: DataFetcherProps<T>) => {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);
  
  useEffect(() => {
    fetch(url)
      .then(res => res.json())
      .then(setData)
      .catch(setError)
      .finally(() => setLoading(false));
  }, [url]);
  
  return <>{render(data, loading, error)}</>;
};

// Extended via render prop - no modification needed
<DataFetcher<Product[]>
  url="/api/products"
  render={(products, loading, error) => {
    if (loading) return <Spinner />;
    if (error) return <Error message={error.message} />;
    return <ProductList products={products || []} />;
  }}
/>
```

### 4. Compound Components Pattern

**What it means**: Extend via component composition.

**Example**:
```typescript
// Base component with sub-components
const Modal = {
  Root: ({ children, isOpen, onClose }: ModalRootProps) => (
    isOpen ? <div className="modal-overlay" onClick={onClose}>{children}</div> : null
  ),
  Header: ({ children }: { children: React.ReactNode }) => (
    <div className="modal-header">{children}</div>
  ),
  Body: ({ children }: { children: React.ReactNode }) => (
    <div className="modal-body">{children}</div>
  ),
  Footer: ({ children }: { children: React.ReactNode }) => (
    <div className="modal-footer">{children}</div>
  ),
};

// Extended via composition - no modification needed
<Modal.Root isOpen={isOpen} onClose={handleClose}>
  <Modal.Header>
    <h2>Custom Title</h2>
  </Modal.Header>
  <Modal.Body>
    <p>Custom content</p>
  </Modal.Body>
  <Modal.Footer>
    <Button onClick={handleSave}>Save</Button>
    <Button variant="secondary" onClick={handleClose}>Cancel</Button>
  </Modal.Footer>
</Modal.Root>
```

### 5. Higher-Order Components (HOCs)

**What it means**: Extend via component wrapping.

**Example**:
```typescript
// HOC for extending components
const withLoading = <P extends object>(Component: React.ComponentType<P>) => {
  return (props: P & { loading?: boolean }) => {
    if (props.loading) {
      return <Spinner />;
    }
    return <Component {...(props as P)} />;
  };
};

// Extended via HOC - no modification needed
const ProductListWithLoading = withLoading(ProductList);

<ProductListWithLoading products={products} loading={isLoading} />
```

## How to Apply OCP in React

### 1. Use Props for Customization

**What it means**: Allow customization via props instead of hard-coding values.

**How to do it**:
- Replace hard-coded values with props
- Use TypeScript unions for variant types
- Provide sensible defaults
- Allow className for styling customization

**Example**:
```typescript
// Before: Hard-coded
<button className="btn-primary">Click</button>

// After: Extensible
<Button variant="primary" size="medium">Click</Button>
<Button variant="secondary" size="large">Click</Button>
```

### 2. Support Children Prop

**What it means**: Allow components to be extended via children.

**How to do it**:
- Accept `children` prop
- Render children in appropriate location
- Don't restrict what children can be

**Example**:
```typescript
// Before: Hard-coded content
<div>
  <h2>Title</h2>
  <p>Content</p>
</div>

// After: Extensible via children
<Card>
  <h2>Any Title</h2>
  <p>Any Content</p>
  <Button>Any Action</Button>
</Card>
```

### 3. Use Render Props for Behavior

**What it means**: Allow behavior customization via function props.

**How to do it**:
- Accept render functions as props
- Call render functions with necessary data
- Provide default rendering if no render prop

**Example**:
```typescript
// Extensible rendering
<List
  items={products}
  renderItem={(product) => <ProductCard product={product} />}
/>
```

### 4. Compose Components

**What it means**: Build complex components from simple ones.

**How to do it**:
- Create small, focused components
- Compose them for complex features
- Don't create "God components"

**Example**:
```typescript
// Composed from simple components
<Modal>
  <Modal.Header>Title</Modal.Header>
  <Modal.Body>Content</Modal.Body>
  <Modal.Footer>Actions</Modal.Footer>
</Modal>
```

## React-Specific OCP Guidelines

### Component Design

- **Props over hard-coding**: Use props for all customizable values
- **Children support**: Allow components to be extended via children
- **Render props**: Use render props for flexible rendering
- **Composition**: Build complex UIs from simple components

### TypeScript Interfaces

- **Union types**: Use union types for variants (e.g., `'primary' | 'secondary'`)
- **Optional props**: Make non-essential props optional
- **Generic types**: Use generics for reusable components
- **Extensible interfaces**: Design interfaces that can be extended

### Styling

- **CSS classes**: Use className prop for styling customization
- **CSS variables**: Use CSS variables for theme customization
- **Style props**: Allow style prop for inline customization
- **Theme support**: Support theme customization via props

## Exercise: Make Components Extensible

### Objective

Refactor hard-coded components in the reference application to be extensible via props and composition.

### Task

1. **Refactor Button Component**:
   - Open `frontend/reference-application/React/src/components/Button.tsx`
   - Make it extensible via props (variant, size, onClick, etc.)
   - Create extended versions via composition (IconButton, LoadingButton)
   - Ensure no source code modification needed for new variants

2. **Refactor ProductList Component**:
   - Open `frontend/reference-application/React/src/components/ProductList.tsx`
   - Make layout configurable via props
   - Add render prop support for custom product rendering
   - Allow className for styling customization

3. **Create New Variants**:
   - Create a "Delete" button variant (no Button.tsx modification)
   - Create a compact product list layout (no ProductList.tsx modification)
   - Create a product list with custom card rendering (no ProductList.tsx modification)

4. **Update Tests**:
   - Update tests to work with new extensible components
   - Add tests for extended variants
   - Ensure all tests pass

### Deliverables

- Extensible Button component with variant support
- Extensible ProductList component with layout options
- Extended component examples (IconButton, etc.)
- All tests passing

### Success Criteria

- ✅ Components can be extended without modifying source code
- ✅ New variants can be created via props or composition
- ✅ All existing functionality preserved
- ✅ Tests pass for both base and extended components

### Getting Started

1. Navigate to the reference application:
   ```bash
   cd frontend/reference-application/React
   ```

2. Start with Button component refactoring

3. Then refactor ProductList component

4. Create extended examples

5. Update and run tests

---

**Previous**: [Single Responsibility Principle](../1-Single-class-reponsibility-principle/README.md)  
**Next**: [Liskov Substitution Principle](../3-Liskov-substitution-principle/README.md)
