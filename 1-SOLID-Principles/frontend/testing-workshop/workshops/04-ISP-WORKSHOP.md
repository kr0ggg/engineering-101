# Interface Segregation Principle (ISP) Testing Workshop - React

## Objective

Learn to identify ISP violations in React components, write focused prop interface tests, and refactor fat prop interfaces into role-specific interfaces.

## Prerequisites

- Complete [LSP Workshop](./03-LSP-WORKSHOP.md)
- Understand React prop composition

## The Problem

The `CustomerCard` component receives too many props, many of which are unused, forcing parent components to provide unnecessary data.

## Workshop Steps

### Step 1: Identify Fat Props Interface (15 minutes)

**Current Implementation**:
```typescript
interface CustomerCardProps {
  // Display props
  id: number;
  name: string;
  email: string;
  phone: string;
  address: string;
  avatar: string;
  status: string;
  
  // Action props
  onEdit: (id: number) => void;
  onDelete: (id: number) => void;
  onView: (id: number) => void;
  onShare: (id: number) => void;
  onExport: (id: number) => void;
  
  // Display options
  showAvatar: boolean;
  showPhone: boolean;
  showAddress: boolean;
  showActions: boolean;
  
  // Styling
  className?: string;
  variant?: 'compact' | 'detailed';
}

function CustomerCard(props: CustomerCardProps) {
  // Uses only some props depending on variant
  // Lots of conditional logic
}
```

**Problem**: 20+ props, many unused in specific use cases!

### Step 2: Analyze Usage Patterns (20 minutes)

**Task**: Document how different parts of the app use the component

```typescript
// List view - only needs basic info
<CustomerCard 
  id={customer.id}
  name={customer.name}
  email={customer.email}
  onView={handleView}
  showAvatar={false}
  showPhone={false}
  showAddress={false}
  showActions={true}
  // 12 unused props!
/>

// Detail view - needs everything
<CustomerCard 
  {...customer}
  {...allActions}
  {...allDisplayOptions}
  // Uses most props
/>
```

### Step 3: Extract Focused Interfaces (30 minutes)

```typescript
// Core display props
interface CustomerDisplayProps {
  id: number;
  name: string;
  email: string;
}

// Extended display props
interface CustomerDetailProps extends CustomerDisplayProps {
  phone?: string;
  address?: string;
  avatar?: string;
  status?: string;
}

// Action props
interface CustomerActionsProps {
  onView?: (id: number) => void;
  onEdit?: (id: number) => void;
  onDelete?: (id: number) => void;
}

// Styling props
interface CustomerCardStyleProps {
  className?: string;
  variant?: 'compact' | 'detailed';
}
```

### Step 4: Create Focused Components (45 minutes)

**Compact Card**:
```typescript
interface CompactCustomerCardProps extends CustomerDisplayProps, CustomerActionsProps {
  className?: string;
}

function CompactCustomerCard({ 
  id, 
  name, 
  email, 
  onView,
  className 
}: CompactCustomerCardProps) {
  return (
    <div className={`customer-card compact ${className || ''}`}>
      <h3>{name}</h3>
      <p>{email}</p>
      {onView && (
        <button onClick={() => onView(id)}>View</button>
      )}
    </div>
  );
}
```

**Tests**:
```typescript
describe('CompactCustomerCard', () => {
  it('should display customer name and email', () => {
    render(
      <CompactCustomerCard 
        id={1} 
        name="John Doe" 
        email="john@example.com" 
      />
    );
    
    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
  });
  
  it('should call onView when button clicked', async () => {
    const user = userEvent.setup();
    const onView = jest.fn();
    
    render(
      <CompactCustomerCard 
        id={1} 
        name="John Doe" 
        email="john@example.com"
        onView={onView}
      />
    );
    
    await user.click(screen.getByRole('button', { name: 'View' }));
    
    expect(onView).toHaveBeenCalledWith(1);
  });
  
  it('should not render button when onView not provided', () => {
    render(
      <CompactCustomerCard 
        id={1} 
        name="John Doe" 
        email="john@example.com" 
      />
    );
    
    expect(screen.queryByRole('button')).not.toBeInTheDocument();
  });
});
```

**Detailed Card**:
```typescript
interface DetailedCustomerCardProps extends CustomerDetailProps, CustomerActionsProps {
  className?: string;
}

function DetailedCustomerCard({ 
  id,
  name, 
  email, 
  phone,
  address,
  avatar,
  status,
  onView,
  onEdit,
  onDelete,
  className 
}: DetailedCustomerCardProps) {
  return (
    <div className={`customer-card detailed ${className || ''}`}>
      {avatar && <img src={avatar} alt={name} />}
      <h3>{name}</h3>
      <p>{email}</p>
      {phone && <p>{phone}</p>}
      {address && <p>{address}</p>}
      {status && <span className="status">{status}</span>}
      
      <div className="actions">
        {onView && <button onClick={() => onView(id)}>View</button>}
        {onEdit && <button onClick={() => onEdit(id)}>Edit</button>}
        {onDelete && <button onClick={() => onDelete(id)}>Delete</button>}
      </div>
    </div>
  );
}
```

**Tests**:
```typescript
describe('DetailedCustomerCard', () => {
  const defaultProps = {
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
  };
  
  it('should display all provided details', () => {
    render(
      <DetailedCustomerCard 
        {...defaultProps}
        phone="555-1234"
        address="123 Main St"
        status="Active"
      />
    );
    
    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
    expect(screen.getByText('555-1234')).toBeInTheDocument();
    expect(screen.getByText('123 Main St')).toBeInTheDocument();
    expect(screen.getByText('Active')).toBeInTheDocument();
  });
  
  it('should render only provided action buttons', () => {
    render(
      <DetailedCustomerCard 
        {...defaultProps}
        onView={jest.fn()}
        onEdit={jest.fn()}
      />
    );
    
    expect(screen.getByRole('button', { name: 'View' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Edit' })).toBeInTheDocument();
    expect(screen.queryByRole('button', { name: 'Delete' })).not.toBeInTheDocument();
  });
});
```

### Step 5: Update Parent Components (30 minutes)

**Before**:
```typescript
function CustomerList() {
  return customers.map(customer => (
    <CustomerCard 
      key={customer.id}
      {...customer}
      onView={handleView}
      showAvatar={false}
      showPhone={false}
      showAddress={false}
      showActions={true}
      // Many unused props
    />
  ));
}
```

**After**:
```typescript
function CustomerList() {
  return customers.map(customer => (
    <CompactCustomerCard 
      key={customer.id}
      id={customer.id}
      name={customer.name}
      email={customer.email}
      onView={handleView}
      // Only what's needed!
    />
  ));
}

function CustomerDetail({ customerId }: { customerId: number }) {
  const customer = useCustomer(customerId);
  
  return (
    <DetailedCustomerCard 
      {...customer}
      onEdit={handleEdit}
      onDelete={handleDelete}
      // Uses detailed props
    />
  );
}
```

**Tests**:
```typescript
describe('CustomerList', () => {
  it('should render compact cards for each customer', () => {
    const customers = [
      { id: 1, name: 'John', email: 'john@example.com' },
      { id: 2, name: 'Jane', email: 'jane@example.com' },
    ];
    
    render(<CustomerList customers={customers} />);
    
    expect(screen.getByText('John')).toBeInTheDocument();
    expect(screen.getByText('Jane')).toBeInTheDocument();
  });
});
```

### Step 6: Verify Improvements (15 minutes)

**Metrics**:

| Metric | Before | After |
|--------|--------|-------|
| Props per component | 20+ | 3-8 |
| Unused props | Many | None |
| Test complexity | High | Low |
| TypeScript errors | Many | None |

## Comparison

### Before ISP
```typescript
// Fat interface - 20+ props
interface CustomerCardProps {
  id: number;
  name: string;
  email: string;
  phone: string;
  address: string;
  // ... 15 more props
}

// Parent must provide all props
<CustomerCard {...allTheProps} />
```

### After ISP
```typescript
// Focused interfaces - 3-8 props each
interface CompactCustomerCardProps {
  id: number;
  name: string;
  email: string;
  onView?: (id: number) => void;
}

// Parent provides only what's needed
<CompactCustomerCard id={1} name="John" email="john@example.com" />
```

## Benefits

- ✅ Components receive only needed props
- ✅ Easier to test (fewer props to mock)
- ✅ Clearer component purpose
- ✅ Better TypeScript support
- ✅ Reduced coupling

## Assessment Checklist

- [ ] Fat prop interfaces identified and split
- [ ] Each component has focused props
- [ ] Parent components updated
- [ ] All tests updated and passing
- [ ] No component receives unused props
- [ ] TypeScript types are correct
- [ ] Test complexity reduced

## Next Steps

1. Apply ISP to other components with fat props
2. Move to [DIP Workshop](./05-DIP-WORKSHOP.md)

---

**Key Takeaway**: ISP in React means creating focused prop interfaces. Components should only receive props they actually use.
