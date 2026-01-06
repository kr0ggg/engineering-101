# Dependency Inversion Principle (DIP) Testing Workshop - React

## Objective

Learn to identify DIP violations in React components, write testable components using dependency injection, and refactor concrete dependencies to abstractions.

## Prerequisites

- Complete [ISP Workshop](./04-ISP-WORKSHOP.md)
- Understand React hooks and context

## The Problem

The `CustomerList` component directly imports and uses API functions, making it hard to test and tightly coupled to the API implementation.

## Workshop Steps

### Step 1: Identify DIP Violation (15 minutes)

**Current Implementation**:
```typescript
import { fetchCustomers } from './api/customers';

function CustomerList() {
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [loading, setLoading] = useState(false);
  
  useEffect(() => {
    setLoading(true);
    fetchCustomers()
      .then(setCustomers)
      .finally(() => setLoading(false));
  }, []);
  
  return (
    <div>
      {loading && <div>Loading...</div>}
      {customers.map(c => <CustomerCard key={c.id} customer={c} />)}
    </div>
  );
}
```

**Problems**:
- Hard to test (uses real API)
- Tightly coupled to `fetchCustomers` implementation
- Can't swap API implementations
- Violates DIP (depends on low-level module)

### Step 2: Attempt to Test (20 minutes)

**Current Test Challenges**:
```typescript
describe('CustomerList', () => {
  it('should display customers', async () => {
    render(<CustomerList />);
    
    // Problem: Uses real fetchCustomers function
    // Need to mock the entire module
    // Brittle and hard to maintain
  });
});
```

### Step 3: Create Abstraction with Props (30 minutes)

**Refactor to Accept Function as Prop**:
```typescript
interface CustomerListProps {
  fetchCustomers: () => Promise<Customer[]>;
}

function CustomerList({ fetchCustomers }: CustomerListProps) {
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [loading, setLoading] = useState(false);
  
  useEffect(() => {
    setLoading(true);
    fetchCustomers()
      .then(setCustomers)
      .finally(() => setLoading(false));
  }, [fetchCustomers]);
  
  return (
    <div>
      {loading && <div role="status">Loading...</div>}
      {customers.map(c => <CustomerCard key={c.id} customer={c} />)}
    </div>
  );
}
```

**Now Easy to Test**:
```typescript
describe('CustomerList', () => {
  it('should display customers after loading', async () => {
    const mockFetchCustomers = jest.fn().mockResolvedValue([
      { id: 1, name: 'John', email: 'john@example.com' },
      { id: 2, name: 'Jane', email: 'jane@example.com' },
    ]);
    
    render(<CustomerList fetchCustomers={mockFetchCustomers} />);
    
    expect(screen.getByRole('status')).toBeInTheDocument();
    
    expect(await screen.findByText('John')).toBeInTheDocument();
    expect(screen.getByText('Jane')).toBeInTheDocument();
    expect(screen.queryByRole('status')).not.toBeInTheDocument();
  });
  
  it('should handle fetch errors', async () => {
    const mockFetchCustomers = jest.fn().mockRejectedValue(
      new Error('Network error')
    );
    
    render(<CustomerList fetchCustomers={mockFetchCustomers} />);
    
    expect(await screen.findByText(/error/i)).toBeInTheDocument();
  });
});
```

### Step 4: Extract Custom Hook (45 minutes)

**Better Pattern - Custom Hook**:
```typescript
interface UseCustomersResult {
  customers: Customer[];
  loading: boolean;
  error: Error | null;
  refetch: () => void;
}

function useCustomers(
  fetchCustomers: () => Promise<Customer[]>
): UseCustomersResult {
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);
  
  const loadCustomers = useCallback(() => {
    setLoading(true);
    setError(null);
    fetchCustomers()
      .then(setCustomers)
      .catch(setError)
      .finally(() => setLoading(false));
  }, [fetchCustomers]);
  
  useEffect(() => {
    loadCustomers();
  }, [loadCustomers]);
  
  return { customers, loading, error, refetch: loadCustomers };
}
```

**Hook Tests**:
```typescript
describe('useCustomers', () => {
  it('should fetch customers on mount', async () => {
    const mockFetch = jest.fn().mockResolvedValue([
      { id: 1, name: 'John', email: 'john@example.com' },
    ]);
    
    const { result } = renderHook(() => useCustomers(mockFetch));
    
    expect(result.current.loading).toBe(true);
    
    await waitFor(() => {
      expect(result.current.loading).toBe(false);
    });
    
    expect(result.current.customers).toHaveLength(1);
    expect(result.current.error).toBeNull();
  });
  
  it('should handle fetch errors', async () => {
    const mockFetch = jest.fn().mockRejectedValue(new Error('Network error'));
    
    const { result } = renderHook(() => useCustomers(mockFetch));
    
    await waitFor(() => {
      expect(result.current.loading).toBe(false);
    });
    
    expect(result.current.error).toBeInstanceOf(Error);
    expect(result.current.customers).toHaveLength(0);
  });
  
  it('should refetch when refetch called', async () => {
    const mockFetch = jest.fn().mockResolvedValue([]);
    
    const { result } = renderHook(() => useCustomers(mockFetch));
    
    await waitFor(() => {
      expect(result.current.loading).toBe(false);
    });
    
    act(() => {
      result.current.refetch();
    });
    
    expect(mockFetch).toHaveBeenCalledTimes(2);
  });
});
```

**Component Using Hook**:
```typescript
interface CustomerListProps {
  fetchCustomers: () => Promise<Customer[]>;
}

function CustomerList({ fetchCustomers }: CustomerListProps) {
  const { customers, loading, error } = useCustomers(fetchCustomers);
  
  if (loading) return <div role="status">Loading...</div>;
  if (error) return <div role="alert">Error: {error.message}</div>;
  
  return (
    <div>
      {customers.map(c => <CustomerCard key={c.id} customer={c} />)}
    </div>
  );
}
```

### Step 5: Use Context for App-Wide Dependencies (45 minutes)

**Create API Context**:
```typescript
interface CustomerAPI {
  fetchCustomers: () => Promise<Customer[]>;
  createCustomer: (customer: Omit<Customer, 'id'>) => Promise<Customer>;
  updateCustomer: (customer: Customer) => Promise<Customer>;
  deleteCustomer: (id: number) => Promise<void>;
}

const CustomerAPIContext = createContext<CustomerAPI | null>(null);

export function CustomerAPIProvider({ 
  children,
  api 
}: { 
  children: React.ReactNode;
  api: CustomerAPI;
}) {
  return (
    <CustomerAPIContext.Provider value={api}>
      {children}
    </CustomerAPIContext.Provider>
  );
}

export function useCustomerAPI() {
  const context = useContext(CustomerAPIContext);
  if (!context) {
    throw new Error('useCustomerAPI must be used within CustomerAPIProvider');
  }
  return context;
}
```

**Component Using Context**:
```typescript
function CustomerList() {
  const api = useCustomerAPI();
  const { customers, loading, error } = useCustomers(api.fetchCustomers);
  
  if (loading) return <div role="status">Loading...</div>;
  if (error) return <div role="alert">Error: {error.message}</div>;
  
  return (
    <div>
      {customers.map(c => <CustomerCard key={c.id} customer={c} />)}
    </div>
  );
}
```

**Test with Context**:
```typescript
function renderWithAPI(
  ui: React.ReactElement,
  api: Partial<CustomerAPI> = {}
) {
  const defaultAPI: CustomerAPI = {
    fetchCustomers: jest.fn().mockResolvedValue([]),
    createCustomer: jest.fn(),
    updateCustomer: jest.fn(),
    deleteCustomer: jest.fn(),
    ...api,
  };
  
  return render(
    <CustomerAPIProvider api={defaultAPI}>
      {ui}
    </CustomerAPIProvider>
  );
}

describe('CustomerList with Context', () => {
  it('should fetch and display customers', async () => {
    const mockFetch = jest.fn().mockResolvedValue([
      { id: 1, name: 'John', email: 'john@example.com' },
    ]);
    
    renderWithAPI(<CustomerList />, { fetchCustomers: mockFetch });
    
    expect(await screen.findByText('John')).toBeInTheDocument();
  });
});
```

### Step 6: Configure Real Implementation (20 minutes)

**App Setup**:
```typescript
import { fetchCustomers, createCustomer, updateCustomer, deleteCustomer } from './api/customers';

function App() {
  const customerAPI: CustomerAPI = {
    fetchCustomers,
    createCustomer,
    updateCustomer,
    deleteCustomer,
  };
  
  return (
    <CustomerAPIProvider api={customerAPI}>
      <Router>
        <Routes>
          <Route path="/customers" element={<CustomerList />} />
          <Route path="/customers/:id" element={<CustomerDetail />} />
        </Routes>
      </Router>
    </CustomerAPIProvider>
  );
}
```

**Test Setup**:
```typescript
// test-utils.tsx
export function renderWithProviders(
  ui: React.ReactElement,
  { api, ...options }: { api?: Partial<CustomerAPI> } = {}
) {
  const mockAPI: CustomerAPI = {
    fetchCustomers: jest.fn().mockResolvedValue([]),
    createCustomer: jest.fn(),
    updateCustomer: jest.fn(),
    deleteCustomer: jest.fn(),
    ...api,
  };
  
  return render(
    <CustomerAPIProvider api={mockAPI}>
      {ui}
    </CustomerAPIProvider>,
    options
  );
}
```

### Step 7: Verify Testability (15 minutes)

**Easy to Test Different Scenarios**:
```typescript
describe('CustomerList scenarios', () => {
  it('should handle empty list', async () => {
    renderWithProviders(<CustomerList />, {
      api: { fetchCustomers: jest.fn().mockResolvedValue([]) }
    });
    
    expect(await screen.findByText(/no customers/i)).toBeInTheDocument();
  });
  
  it('should handle network errors', async () => {
    renderWithProviders(<CustomerList />, {
      api: { 
        fetchCustomers: jest.fn().mockRejectedValue(new Error('Network error'))
      }
    });
    
    expect(await screen.findByText(/network error/i)).toBeInTheDocument();
  });
  
  it('should handle slow responses', async () => {
    const slowFetch = jest.fn(() => 
      new Promise(resolve => setTimeout(() => resolve([]), 1000))
    );
    
    renderWithProviders(<CustomerList />, {
      api: { fetchCustomers: slowFetch }
    });
    
    expect(screen.getByRole('status')).toBeInTheDocument();
  });
});
```

## Comparison

### Before DIP
```typescript
// Tightly coupled to concrete API
import { fetchCustomers } from './api/customers';

function CustomerList() {
  useEffect(() => {
    fetchCustomers().then(setCustomers);
  }, []);
}

// Hard to test
test('CustomerList', () => {
  // Must mock entire module
  jest.mock('./api/customers');
});
```

### After DIP
```typescript
// Depends on abstraction
function CustomerList() {
  const api = useCustomerAPI();
  const { customers } = useCustomers(api.fetchCustomers);
}

// Easy to test
test('CustomerList', () => {
  renderWithProviders(<CustomerList />, {
    api: { fetchCustomers: mockFn }
  });
});
```

## Benefits

- ✅ Easy to test with mocks
- ✅ Easy to swap implementations
- ✅ Loose coupling
- ✅ Reusable hooks
- ✅ Better separation of concerns

## Assessment Checklist

- [ ] Components depend on abstractions (props/context)
- [ ] Dependencies injected via props or context
- [ ] No direct imports of concrete implementations
- [ ] Easy to test with mocks
- [ ] Custom hooks extract reusable logic
- [ ] All tests pass
- [ ] Real implementation configured at app level

## Summary

**DIP Transformation in React**:
1. Identify concrete dependencies (API calls, services)
2. Create abstractions (function props, context)
3. Inject dependencies via props or context
4. Extract reusable logic to custom hooks
5. Test with mocks
6. Configure real implementations at app root

---

**Key Takeaway**: DIP in React means components depend on abstractions (props, context) not concrete implementations. Use dependency injection for testability and flexibility.
