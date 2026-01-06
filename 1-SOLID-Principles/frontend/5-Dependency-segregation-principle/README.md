# Dependency Inversion Principle (DIP) - React Edition

## Name
**Dependency Inversion Principle** - The "D" in SOLID

## Goal of the Principle

In React, the Dependency Inversion Principle means: **Components and hooks should depend on abstractions (interfaces/types), not concrete implementations**. High-level components should not depend on low-level implementations like API calls or services directly.

## React-Specific Application

### What It Means in React

In React development, DIP applies to:

- **Service Abstractions**: Depend on service interfaces, not concrete API implementations
- **Hook Abstractions**: Hooks should depend on abstractions
- **Dependency Injection**: Inject dependencies via props or context
- **Testing**: Easy mocking with abstracted dependencies

### React Dependency Management

React components and hooks should:
- **Depend on interfaces**: Use TypeScript interfaces for services
- **Inject dependencies**: Receive dependencies via props or context
- **Avoid direct imports**: Don't directly import concrete implementations
- **Support testing**: Easy to mock dependencies for testing

**The Problem**: When components depend on concrete implementations:
- Cannot swap implementations (e.g., different APIs)
- Hard to test (must mock concrete implementations)
- Tight coupling to specific services
- Difficult to reuse in different contexts

## Theoretical Foundation

### Dependency Inversion Theory

DIP inverts the traditional dependency hierarchy:
- **Traditional**: Components → Services → APIs
- **Inverted**: Components → Interfaces ← Services → APIs

### Abstraction and Encapsulation

DIP relies on:
- **Service interfaces**: Define contracts for services
- **Implementation hiding**: Hide concrete implementations behind interfaces
- **Polymorphism**: Different implementations can satisfy same interface

### Inversion of Control (IoC)

DIP is related to IoC:
- **Dependency injection**: Dependencies provided from outside
- **Service location**: Dependencies retrieved from context or props
- **Configuration**: System behavior configured via dependencies

## Consequences of Violating DIP in React

### React-Specific Issues

**Rigid Architecture**
- Components directly depend on specific API implementations
- Cannot swap APIs without changing components
- Changes to API structure break components
- System becomes tightly coupled

**Testing Difficulties**
- Cannot test components without real API
- Must mock concrete implementations
- Complex test setup required
- Integration tests become only viable option

**Flexibility Problems**
- Cannot use different APIs (REST, GraphQL, mock)
- Configuration changes require code modifications
- Cannot easily switch between development and production APIs
- Components can't be reused with different backends

**Reusability Issues**
- Components tied to specific API structure
- Cannot reuse components in different projects
- Must duplicate code for different APIs
- Reduced component portability

## React-Specific Examples

### ❌ Violating DIP - Direct Dependencies

The `useProductData` hook and components in our reference application violate DIP:

**Location**: 
- `frontend/reference-application/React/src/hooks/useProductData.ts`
- `frontend/reference-application/React/src/services/api.ts`

#### Direct API Dependency

```typescript
// api.ts - VIOLATES DIP
// Direct dependency on fetch API, hard-coded endpoints
const API_BASE_URL = '/api'; // VIOLATION: Hard-coded endpoint

export const getProducts = async (): Promise<Product[]> => {
  // VIOLATION: Direct dependency on fetch API
  const response = await fetch(`${API_BASE_URL}/products`);
  if (!response.ok) {
    throw new Error('Failed to fetch products');
  }
  return response.json();
};
```

#### Direct Service Dependency

```typescript
// useProductData.ts - VIOLATES DIP
// Directly depends on concrete api.ts implementation
import { getProducts } from '../services/api'; // VIOLATION: Direct dependency

export const useProductData = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchProducts = async () => {
      setLoading(true);
      setError(null);
      try {
        // VIOLATION: Direct call to concrete implementation
        const data = await getProducts();
        setProducts(data);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Failed to fetch products');
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, []);

  return { products, loading, error };
};
```

#### Component with Direct Dependency

```typescript
// ProductList.tsx - VIOLATES DIP (if it directly uses useProductData)
import { useProductData } from '../hooks/useProductData';

export const ProductList: React.FC = () => {
  // VIOLATION: Direct dependency on concrete hook implementation
  const { products, loading, error } = useProductData();
  
  // Cannot swap implementation for testing or different APIs
};
```

**Problems:**
- ❌ Cannot swap API implementations
- ❌ Hard to test (must mock fetch)
- ❌ Tight coupling to specific API structure
- ❌ Cannot use mock data for development

### ✅ Refactored - Applying DIP

Here's how to apply Dependency Inversion:

#### 1. Define Service Abstraction

```typescript
// services/ProductService.ts - Abstraction (interface)
export interface ProductService {
  getProducts(): Promise<Product[]>;
  getProduct(id: number): Promise<Product | null>;
}

// This is the abstraction that components depend on
```

#### 2. Create Concrete Implementations

```typescript
// services/ApiProductService.ts - Concrete implementation
import type { ProductService, Product } from '../types';

export class ApiProductService implements ProductService {
  private baseUrl: string;

  constructor(baseUrl: string = '/api') {
    this.baseUrl = baseUrl;
  }

  async getProducts(): Promise<Product[]> {
    const response = await fetch(`${this.baseUrl}/products`);
    if (!response.ok) {
      throw new Error('Failed to fetch products');
    }
    return response.json();
  }

  async getProduct(id: number): Promise<Product | null> {
    const response = await fetch(`${this.baseUrl}/products/${id}`);
    if (!response.ok) {
      return null;
    }
    return response.json();
  }
}

// services/MockProductService.ts - Mock implementation for testing
export class MockProductService implements ProductService {
  private products: Product[] = [
    { id: 1, name: 'Test Product', price: 100, sku: 'TEST001', stockQuantity: 10 },
    { id: 2, name: 'Another Product', price: 200, sku: 'TEST002', stockQuantity: 20 },
  ];

  async getProducts(): Promise<Product[]> {
    // Simulate API delay
    await new Promise(resolve => setTimeout(resolve, 100));
    return [...this.products];
  }

  async getProduct(id: number): Promise<Product | null> {
    await new Promise(resolve => setTimeout(resolve, 50));
    return this.products.find(p => p.id === id) || null;
  }
}

// services/GraphQLProductService.ts - Alternative implementation
export class GraphQLProductService implements ProductService {
  private endpoint: string;

  constructor(endpoint: string) {
    this.endpoint = endpoint;
  }

  async getProducts(): Promise<Product[]> {
    const query = `
      query {
        products {
          id
          name
          price
          sku
          stockQuantity
        }
      }
    `;
    
    const response = await fetch(this.endpoint, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ query }),
    });
    
    const { data } = await response.json();
    return data.products;
  }

  async getProduct(id: number): Promise<Product | null> {
    // GraphQL implementation
    return null; // Simplified
  }
}
```

#### 3. Update Hook to Depend on Abstraction

```typescript
// hooks/useProducts.ts - Depends on abstraction
import { useState, useEffect } from 'react';
import type { ProductService, Product } from '../types';

export const useProducts = (productService: ProductService) => {
  // Depends on abstraction, not concrete implementation
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchProducts = async () => {
      setLoading(true);
      setError(null);
      try {
        // Uses abstraction - can work with any implementation
        const data = await productService.getProducts();
        setProducts(data);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Failed to fetch products');
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, [productService]);

  return { products, loading, error };
};
```

#### 4. Inject Dependencies via Props

```typescript
// components/ProductList.tsx - Receives dependency via props
import React from 'react';
import { useProducts } from '../hooks/useProducts';
import type { ProductService } from '../types';

interface ProductListProps {
  productService: ProductService; // Depends on abstraction
}

export const ProductList: React.FC<ProductListProps> = ({ productService }) => {
  // Uses abstraction - easy to test with mock
  const { products, loading, error } = useProducts(productService);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div>
      {products.map(product => (
        <div key={product.id}>{product.name}</div>
      ))}
    </div>
  );
};
```

#### 5. Inject Dependencies via Context

```typescript
// contexts/ServiceContext.tsx - Dependency injection via context
import React, { createContext, useContext } from 'react';
import type { ProductService } from '../types';

interface ServiceContextValue {
  productService: ProductService;
  userService?: UserService;
  orderService?: OrderService;
}

const ServiceContext = createContext<ServiceContextValue | null>(null);

export const ServiceProvider: React.FC<{
  services: ServiceContextValue;
  children: React.ReactNode;
}> = ({ services, children }) => {
  return (
    <ServiceContext.Provider value={services}>
      {children}
    </ServiceContext.Provider>
  );
};

export const useServices = () => {
  const context = useContext(ServiceContext);
  if (!context) {
    throw new Error('useServices must be used within ServiceProvider');
  }
  return context;
};

// Usage in components
export const ProductList: React.FC = () => {
  const { productService } = useServices(); // Get from context
  const { products, loading, error } = useProducts(productService);
  
  // Component implementation
};
```

#### 6. App Setup with Dependency Injection

```typescript
// App.tsx - Inject dependencies
import { ApiProductService } from './services/ApiProductService';
import { MockProductService } from './services/MockProductService';
import { ServiceProvider } from './contexts/ServiceContext';

function App() {
  // Can easily swap implementations
  const productService = process.env.NODE_ENV === 'test'
    ? new MockProductService()
    : new ApiProductService();

  return (
    <ServiceProvider services={{ productService }}>
      <ProductList />
    </ServiceProvider>
  );
}
```

**Benefits:**
- ✅ Can swap implementations (REST, GraphQL, Mock)
- ✅ Easy to test (inject mock services)
- ✅ Loose coupling to specific APIs
- ✅ Reusable in different contexts

## React Dependency Injection Patterns

### 1. Props Injection

**What it means**: Pass dependencies via component props.

**How to do it**:
- Accept service interfaces as props
- Inject services when using components
- Keep components testable

**Example**:
```typescript
// Component receives service via props
<ProductList productService={productService} />

// Easy to test
<ProductList productService={mockProductService} />
```

### 2. Context Providers

**What it means**: Use React Context for dependency injection.

**How to do it**:
- Create service context
- Provide services via context provider
- Consume services via context hook

**Example**:
```typescript
<ServiceProvider services={{ productService }}>
  <App />
</ServiceProvider>

// In components
const { productService } = useServices();
```

### 3. Custom Hooks with Abstractions

**What it means**: Hooks depend on abstractions, not concretions.

**How to do it**:
- Accept service interfaces as parameters
- Don't import concrete services
- Allow dependency injection

**Example**:
```typescript
// Hook accepts abstraction
const useProducts = (productService: ProductService) => {
  // Implementation
};

// Usage
const { products } = useProducts(productService);
```

### 4. Factory Functions

**What it means**: Create services via factory functions.

**How to do it**:
- Factory functions return service instances
- Can configure services
- Easy to swap implementations

**Example**:
```typescript
const createProductService = (config: ServiceConfig): ProductService => {
  if (config.type === 'api') {
    return new ApiProductService(config.baseUrl);
  }
  if (config.type === 'graphql') {
    return new GraphQLProductService(config.endpoint);
  }
  return new MockProductService();
};
```

## How to Apply DIP in React

### 1. Define Service Interfaces

**What it means**: Create TypeScript interfaces for services.

**How to do it**:
- Define interfaces for each service type
- Include all methods the service should have
- Keep interfaces focused and minimal

**Example**:
```typescript
// Define abstraction
interface ProductService {
  getProducts(): Promise<Product[]>;
  getProduct(id: number): Promise<Product | null>;
}
```

### 2. Create Implementations

**What it means**: Implement interfaces with concrete classes.

**How to do it**:
- Create classes that implement interfaces
- Can have multiple implementations
- Each for different use cases (API, Mock, GraphQL)

**Example**:
```typescript
class ApiProductService implements ProductService {
  // Implementation
}

class MockProductService implements ProductService {
  // Implementation
}
```

### 3. Inject Dependencies

**What it means**: Pass dependencies to components/hooks.

**How to do it**:
- Via props for component-specific dependencies
- Via context for app-wide dependencies
- Via hooks for reusable logic

**Example**:
```typescript
// Via props
<ProductList productService={productService} />

// Via context
const { productService } = useServices();
```

### 4. Avoid Direct Imports

**What it means**: Don't directly import concrete implementations.

**How to do it**:
- Import interfaces/types, not implementations
- Receive implementations via injection
- Keep components decoupled

**Example**:
```typescript
// Bad: Direct import
import { getProducts } from './services/api';

// Good: Dependency injection
const useProducts = (productService: ProductService) => {
  // Use injected service
};
```

## Exercise: Implement Dependency Inversion

### Objective

Refactor components and hooks to depend on abstractions instead of concrete implementations.

### Task

1. **Create Service Interfaces**:
   - Create `ProductService` interface
   - Create `UserService` interface (if needed)
   - Define all required methods

2. **Refactor API Service**:
   - Update `api.ts` to implement `ProductService` interface
   - Create `ApiProductService` class
   - Keep existing functionality

3. **Create Mock Service**:
   - Create `MockProductService` class
   - Implement `ProductService` interface
   - Use for testing

4. **Refactor Hook**:
   - Update `useProductData.ts` to accept `ProductService` interface
   - Remove direct import of `api.ts`
   - Inject service as parameter

5. **Refactor Components**:
   - Update components to receive services via props or context
   - Create service context if needed
   - Update App.tsx to inject services

6. **Update Tests**:
   - Update tests to use mock services
   - Test with different service implementations
   - Ensure all tests pass

### Deliverables

- Service interfaces defined
- Concrete service implementations
- Refactored hooks depending on abstractions
- Dependency injection setup
- Updated tests using mocks

### Success Criteria

- ✅ Components/hooks depend on interfaces, not implementations
- ✅ Can swap service implementations easily
- ✅ Easy to test with mock services
- ✅ All tests pass
- ✅ No direct imports of concrete services

### Getting Started

1. Navigate to the reference application:
   ```bash
   cd frontend/reference-application/React
   ```

2. Create service interfaces

3. Refactor API service to implement interface

4. Create mock service

5. Update hooks to accept service interface

6. Update components to inject dependencies

7. Update and run tests

---

**Previous**: [Interface Segregation Principle](../4-Interface-segregation-principle/README.md)

---

## Summary

You've now learned how to apply all five SOLID principles in React:

1. **Single Responsibility**: One component/hook = one purpose
2. **Open/Closed**: Extensible via props/composition
3. **Liskov Substitution**: Components honor contracts
4. **Interface Segregation**: Minimal, focused props
5. **Dependency Inversion**: Depend on abstractions

Apply these principles to build maintainable, testable, and reusable React applications!
