# Open/Closed Principle (OCP) Testing Workshop - React

## Objective

Learn to identify OCP violations in React components, write tests for extensible components, and refactor using composition and polymorphism.

## Prerequisites

- Complete [SRP Workshop](./01-TESTING-WORKSHOP.md)
- Understand React composition patterns

## The Problem

The `NotificationDisplay` component uses conditional rendering based on type, requiring modification to add new notification types.

## Workshop Steps

### Step 1: Write Characterization Tests (20 minutes)

**Current Implementation**:
```typescript
interface NotificationDisplayProps {
  notification: Notification;
}

function NotificationDisplay({ notification }: NotificationDisplayProps) {
  if (notification.type === 'success') {
    return (
      <div className="success">
        <CheckIcon />
        <span>{notification.message}</span>
      </div>
    );
  }
  
  if (notification.type === 'error') {
    return (
      <div className="error">
        <ErrorIcon />
        <span>{notification.message}</span>
      </div>
    );
  }
  
  if (notification.type === 'warning') {
    return (
      <div className="warning">
        <WarningIcon />
        <span>{notification.message}</span>
      </div>
    );
  }
  
  return null;
}
```

**Tests**:
```typescript
describe('NotificationDisplay', () => {
  it('should display success notification', () => {
    const notification = { type: 'success', message: 'Success!' };
    render(<NotificationDisplay notification={notification} />);
    
    expect(screen.getByText('Success!')).toBeInTheDocument();
    expect(screen.getByRole('img')).toHaveClass('check-icon');
  });
  
  it('should display error notification', () => {
    const notification = { type: 'error', message: 'Error!' };
    render(<NotificationDisplay notification={notification} />);
    
    expect(screen.getByText('Error!')).toBeInTheDocument();
  });
});
```

### Step 2: Refactor Using Component Map (30 minutes)

**Create Specific Components**:
```typescript
interface NotificationProps {
  message: string;
}

function SuccessNotification({ message }: NotificationProps) {
  return (
    <div className="notification success">
      <CheckIcon />
      <span>{message}</span>
    </div>
  );
}

function ErrorNotification({ message }: NotificationProps) {
  return (
    <div className="notification error">
      <ErrorIcon />
      <span>{message}</span>
    </div>
  );
}

function WarningNotification({ message }: NotificationProps) {
  return (
    <div className="notification warning">
      <WarningIcon />
      <span>{message}</span>
    </div>
  );
}
```

**Tests for Each Component**:
```typescript
describe('SuccessNotification', () => {
  it('should display success message with icon', () => {
    render(<SuccessNotification message="Success!" />);
    
    expect(screen.getByText('Success!')).toBeInTheDocument();
    expect(screen.getByRole('img')).toBeInTheDocument();
  });
});

describe('ErrorNotification', () => {
  it('should display error message with icon', () => {
    render(<ErrorNotification message="Error!" />);
    
    expect(screen.getByText('Error!')).toBeInTheDocument();
  });
});
```

### Step 3: Use Component Map Pattern (30 minutes)

```typescript
const notificationComponents = {
  success: SuccessNotification,
  error: ErrorNotification,
  warning: WarningNotification,
} as const;

type NotificationType = keyof typeof notificationComponents;

interface Notification {
  type: NotificationType;
  message: string;
}

interface NotificationDisplayProps {
  notification: Notification;
}

function NotificationDisplay({ notification }: NotificationDisplayProps) {
  const Component = notificationComponents[notification.type];
  
  if (!Component) {
    return null;
  }
  
  return <Component message={notification.message} />;
}
```

**Tests**:
```typescript
describe('NotificationDisplay', () => {
  it('should render correct component for success type', () => {
    const notification = { type: 'success' as const, message: 'Success!' };
    render(<NotificationDisplay notification={notification} />);
    
    expect(screen.getByText('Success!')).toBeInTheDocument();
    expect(screen.getByRole('img')).toBeInTheDocument();
  });
  
  it('should render correct component for error type', () => {
    const notification = { type: 'error' as const, message: 'Error!' };
    render(<NotificationDisplay notification={notification} />);
    
    expect(screen.getByText('Error!')).toBeInTheDocument();
  });
  
  it('should handle unknown type gracefully', () => {
    const notification = { type: 'unknown' as any, message: 'Test' };
    const { container } = render(<NotificationDisplay notification={notification} />);
    
    expect(container.firstChild).toBeNull();
  });
});
```

### Step 4: Add New Type Without Modification (20 minutes)

**InfoNotification** (NEW - no modification to existing code):
```typescript
function InfoNotification({ message }: NotificationProps) {
  return (
    <div className="notification info">
      <InfoIcon />
      <span>{message}</span>
    </div>
  );
}

// Just add to the map - no modification to NotificationDisplay!
const notificationComponents = {
  success: SuccessNotification,
  error: ErrorNotification,
  warning: WarningNotification,
  info: InfoNotification,  // NEW
} as const;
```

**Tests**:
```typescript
describe('InfoNotification', () => {
  it('should display info message with icon', () => {
    render(<InfoNotification message="Info!" />);
    
    expect(screen.getByText('Info!')).toBeInTheDocument();
    expect(screen.getByRole('img')).toBeInTheDocument();
  });
});

describe('NotificationDisplay with info type', () => {
  it('should render info notification', () => {
    const notification = { type: 'info' as const, message: 'Info!' };
    render(<NotificationDisplay notification={notification} />);
    
    expect(screen.getByText('Info!')).toBeInTheDocument();
  });
});
```

### Step 5: Alternative Pattern - Render Props (30 minutes)

```typescript
interface NotificationProps {
  message: string;
  icon: React.ReactNode;
  className?: string;
}

function Notification({ message, icon, className }: NotificationProps) {
  return (
    <div className={`notification ${className || ''}`}>
      {icon}
      <span>{message}</span>
    </div>
  );
}

// Usage
function App() {
  return (
    <>
      <Notification 
        message="Success!" 
        icon={<CheckIcon />} 
        className="success" 
      />
      <Notification 
        message="Error!" 
        icon={<ErrorIcon />} 
        className="error" 
      />
    </>
  );
}
```

**Tests**:
```typescript
describe('Notification with render props', () => {
  it('should render with custom icon', () => {
    render(
      <Notification 
        message="Test" 
        icon={<span data-testid="custom-icon">✓</span>} 
      />
    );
    
    expect(screen.getByText('Test')).toBeInTheDocument();
    expect(screen.getByTestId('custom-icon')).toBeInTheDocument();
  });
  
  it('should apply custom className', () => {
    const { container } = render(
      <Notification 
        message="Test" 
        icon={<span>✓</span>} 
        className="custom" 
      />
    );
    
    expect(container.firstChild).toHaveClass('notification', 'custom');
  });
});
```

### Step 6: Verify All Tests Pass (10 minutes)

```bash
npm test
```

**Success Criteria**:
- [ ] All original tests pass
- [ ] New notification type added without modifying NotificationDisplay
- [ ] Each notification component tested independently
- [ ] Component map pattern working correctly

## Comparison

### Before OCP
```typescript
// Must modify this function to add new types
if (notification.type === 'success') { /* ... */ }
if (notification.type === 'error') { /* ... */ }
if (notification.type === 'warning') { /* ... */ }
if (notification.type === 'info') { /* NEW - must modify */ }
```

### After OCP
```typescript
// Just add to map - no modification to component
const notificationComponents = {
  success: SuccessNotification,
  error: ErrorNotification,
  warning: WarningNotification,
  info: InfoNotification,  // NEW - no modification needed
};
```

## Benefits

- ✅ Add new types without modifying existing code
- ✅ Each notification type independently testable
- ✅ Clear separation of concerns
- ✅ Type-safe with TypeScript
- ✅ Easy to maintain

## Assessment Checklist

- [ ] Conditional rendering replaced with composition
- [ ] Each notification component has tests
- [ ] Component map or render props pattern used
- [ ] New type added without modifying display component
- [ ] All tests pass
- [ ] TypeScript types are correct

## Next Steps

1. Apply OCP to other conditional rendering in the codebase
2. Move to [LSP Workshop](./03-LSP-WORKSHOP.md)

---

**Key Takeaway**: OCP in React means using composition patterns (component maps, render props, children) to enable extension without modification.
