# Liskov Substitution Principle (LSP) Testing Workshop - React

## Objective

Learn to identify LSP violations in React components, write contract tests, and ensure component variants can substitute base components without breaking functionality.

## Prerequisites

- Complete [OCP Workshop](./02-OCP-WORKSHOP.md)
- Understand React component composition

## The Problem

The `ReadOnlyInput` component violates LSP by ignoring the `onChange` prop, breaking the contract expected by parent components.

## Workshop Steps

### Step 1: Identify LSP Violation (15 minutes)

**Current Implementation**:
```typescript
interface InputProps {
  value: string;
  onChange: (value: string) => void;
  label: string;
  error?: string;
}

function TextInput({ value, onChange, label, error }: InputProps) {
  return (
    <div>
      <label>{label}</label>
      <input 
        value={value} 
        onChange={(e) => onChange(e.target.value)} 
      />
      {error && <span className="error">{error}</span>}
    </div>
  );
}

function ReadOnlyInput({ value, onChange, label }: InputProps) {
  // Violates LSP - ignores onChange!
  return (
    <div>
      <label>{label}</label>
      <input value={value} disabled />
    </div>
  );
}
```

**Problem**: Parent components expect `onChange` to work, but `ReadOnlyInput` ignores it.

### Step 2: Write Contract Tests (30 minutes)

```typescript
// Base contract that all inputs must satisfy
function testInputContract(
  Component: React.ComponentType<InputProps>,
  componentName: string
) {
  describe(`${componentName} - Input Contract`, () => {
    it('should display label', () => {
      render(
        <Component 
          value="" 
          onChange={jest.fn()} 
          label="Test Label" 
        />
      );
      
      expect(screen.getByText('Test Label')).toBeInTheDocument();
    });
    
    it('should display current value', () => {
      render(
        <Component 
          value="test value" 
          onChange={jest.fn()} 
          label="Test" 
        />
      );
      
      expect(screen.getByDisplayValue('test value')).toBeInTheDocument();
    });
    
    it('should display error when provided', () => {
      render(
        <Component 
          value="" 
          onChange={jest.fn()} 
          label="Test" 
          error="Error message" 
        />
      );
      
      expect(screen.getByText('Error message')).toBeInTheDocument();
    });
  });
}

// Apply contract tests
testInputContract(TextInput, 'TextInput');
testInputContract(ReadOnlyInput, 'ReadOnlyInput'); // FAILS - no error display
```

### Step 3: Test Reveals Violation (10 minutes)

```typescript
describe('ReadOnlyInput', () => {
  it('should call onChange when user types', async () => {
    const user = userEvent.setup();
    const onChange = jest.fn();
    
    render(
      <ReadOnlyInput 
        value="" 
        onChange={onChange} 
        label="Test" 
      />
    );
    
    await user.type(screen.getByRole('textbox'), 'test');
    
    // FAILS - onChange never called because input is disabled!
    expect(onChange).toHaveBeenCalled();
  });
});
```

### Step 4: Refactor to Fix LSP (45 minutes)

**Solution: Separate Interfaces**

```typescript
// Base props for display
interface BaseInputProps {
  value: string;
  label: string;
  error?: string;
}

// Editable input props
interface EditableInputProps extends BaseInputProps {
  onChange: (value: string) => void;
  placeholder?: string;
}

// Read-only input props (no onChange)
interface ReadOnlyInputProps extends BaseInputProps {
  // No onChange - clear contract
}

function TextInput({ value, onChange, label, error, placeholder }: EditableInputProps) {
  return (
    <div className="input-group">
      <label>{label}</label>
      <input 
        value={value} 
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
      />
      {error && <span className="error">{error}</span>}
    </div>
  );
}

function ReadOnlyInput({ value, label, error }: ReadOnlyInputProps) {
  return (
    <div className="input-group">
      <label>{label}</label>
      <input value={value} disabled />
      {error && <span className="error">{error}</span>}
    </div>
  );
}
```

### Step 5: Write New Contract Tests (30 minutes)

**Editable Input Contract**:
```typescript
function testEditableInputContract(
  Component: React.ComponentType<EditableInputProps>,
  componentName: string
) {
  describe(`${componentName} - Editable Contract`, () => {
    it('should call onChange when user types', async () => {
      const user = userEvent.setup();
      const onChange = jest.fn();
      
      render(
        <Component 
          value="" 
          onChange={onChange} 
          label="Test" 
        />
      );
      
      await user.type(screen.getByRole('textbox'), 'test');
      
      expect(onChange).toHaveBeenCalledTimes(4);
      expect(onChange).toHaveBeenLastCalledWith('test');
    });
    
    it('should display placeholder', () => {
      render(
        <Component 
          value="" 
          onChange={jest.fn()} 
          label="Test"
          placeholder="Enter text"
        />
      );
      
      expect(screen.getByPlaceholderText('Enter text')).toBeInTheDocument();
    });
  });
}

testEditableInputContract(TextInput, 'TextInput');
```

**Read-Only Input Contract**:
```typescript
function testReadOnlyInputContract(
  Component: React.ComponentType<ReadOnlyInputProps>,
  componentName: string
) {
  describe(`${componentName} - ReadOnly Contract`, () => {
    it('should display value', () => {
      render(
        <Component 
          value="test value" 
          label="Test" 
        />
      );
      
      expect(screen.getByDisplayValue('test value')).toBeInTheDocument();
    });
    
    it('should be disabled', () => {
      render(
        <Component 
          value="test" 
          label="Test" 
        />
      );
      
      expect(screen.getByRole('textbox')).toBeDisabled();
    });
    
    it('should not accept user input', async () => {
      const user = userEvent.setup();
      render(
        <Component 
          value="original" 
          label="Test" 
        />
      );
      
      const input = screen.getByRole('textbox');
      await user.type(input, 'new');
      
      // Value should not change
      expect(input).toHaveValue('original');
    });
  });
}

testReadOnlyInputContract(ReadOnlyInput, 'ReadOnlyInput');
```

### Step 6: Update Parent Components (20 minutes)

**Before**:
```typescript
function Form() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  
  return (
    <form>
      <TextInput value={name} onChange={setName} label="Name" />
      <ReadOnlyInput value={email} onChange={setEmail} label="Email" />
      {/* ReadOnlyInput ignores onChange - confusing! */}
    </form>
  );
}
```

**After**:
```typescript
function Form() {
  const [name, setName] = useState('');
  const [email] = useState('user@example.com');
  
  return (
    <form>
      <TextInput value={name} onChange={setName} label="Name" />
      <ReadOnlyInput value={email} label="Email" />
      {/* Clear - no onChange prop, can't be edited */}
    </form>
  );
}
```

**Tests**:
```typescript
describe('Form', () => {
  it('should allow editing name field', async () => {
    const user = userEvent.setup();
    render(<Form />);
    
    await user.type(screen.getByLabelText('Name'), 'John Doe');
    
    expect(screen.getByLabelText('Name')).toHaveValue('John Doe');
  });
  
  it('should not allow editing email field', async () => {
    const user = userEvent.setup();
    render(<Form />);
    
    const emailInput = screen.getByLabelText('Email');
    expect(emailInput).toBeDisabled();
    
    await user.type(emailInput, 'new@example.com');
    
    // Value unchanged
    expect(emailInput).toHaveValue('user@example.com');
  });
});
```

### Step 7: Verify All Implementations (15 minutes)

**Success Criteria**:
- [ ] All contract tests pass
- [ ] TextInput passes editable contract
- [ ] ReadOnlyInput passes read-only contract
- [ ] Parent components updated
- [ ] TypeScript types prevent misuse

## Comparison

### Before LSP
```typescript
// Same interface, different behavior
interface InputProps {
  onChange: (value: string) => void; // ReadOnlyInput ignores this!
}

function ReadOnlyInput({ onChange }: InputProps) {
  // Violates contract - onChange ignored
}
```

### After LSP
```typescript
// Different interfaces, clear contracts
interface EditableInputProps {
  onChange: (value: string) => void; // Required
}

interface ReadOnlyInputProps {
  // No onChange - clear it's read-only
}
```

## Benefits

- ✅ Clear contracts for each component type
- ✅ TypeScript prevents misuse
- ✅ No unexpected behavior
- ✅ Easier to test
- ✅ Better developer experience

## Assessment Checklist

- [ ] Contract tests defined for each component type
- [ ] All implementations pass their contracts
- [ ] No unexpected behavior in variants
- [ ] TypeScript types enforce contracts
- [ ] Parent components updated correctly
- [ ] All tests pass

## Next Steps

1. Apply LSP to other component hierarchies
2. Move to [ISP Workshop](./04-ISP-WORKSHOP.md)

---

**Key Takeaway**: LSP in React means components with the same interface should behave consistently. Use different interfaces for different behaviors.
