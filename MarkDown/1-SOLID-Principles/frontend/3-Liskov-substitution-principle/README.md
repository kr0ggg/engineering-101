# Liskov Substitution Principle (LSP) - React Edition

## Name
**Liskov Substitution Principle** - The "L" in SOLID

## Goal of the Principle

In React, the Liskov Substitution Principle means: **Extended components should be substitutable for their base components without breaking functionality**. Components that extend or implement interfaces should honor the contracts established by their base components.

## React-Specific Application

### What It Means in React

In React development, LSP applies to:

- **Component Contracts**: Props interfaces define contracts that extended components must honor
- **Polymorphic Components**: Components that can be used interchangeably
- **Consistent Behavior**: Extended components should behave consistently with base components
- **Props Interfaces**: TypeScript interfaces serve as contracts

### React Component Substitutability

A React component should:
- **Honor the contract**: Maintain the same props interface and behavior
- **Be substitutable**: Can replace base component without breaking functionality
- **Maintain expectations**: Call callbacks and handle events as expected
- **Preserve invariants**: Maintain the same guarantees as the base component

**The Problem**: When extended components break contracts:
- They can't be used interchangeably
- Tests written for base components fail with extended components
- Unexpected behavior when components are swapped
- Breaks polymorphism and component reuse

## Theoretical Foundation

### Behavioral Subtyping

The Liskov Substitution Principle formalizes behavioral subtyping. In React:
- **Base components** define contracts via props interfaces
- **Extended components** must honor these contracts
- **Substitution** should be transparent to consumers

### Contract-Based Design

React components establish contracts through:
- **Props interfaces**: Define what props are expected
- **Callback signatures**: Define how callbacks are called
- **Behavior expectations**: Define how components behave

### Polymorphism in React

React achieves polymorphism through:
- **Component substitution**: Using different components with same interface
- **Props polymorphism**: Same props interface, different implementations
- **Render polymorphism**: Different components rendering same way

## Consequences of Violating LSP in React

### React-Specific Issues

**Runtime Errors and Unexpected Behavior**
- Extended components may not call callbacks as expected
- Props may be handled differently than base component
- State management may differ from base component

**Testing Failures**
- Tests written for base components fail with extended components
- Mock expectations don't match extended component behavior
- Integration tests break when components are swapped

**Polymorphism Breaks**
- Cannot use extended components where base components are expected
- Component libraries become unreliable
- Reusability decreases

**Contract Violations**
- Callbacks not called when expected
- Props ignored or handled differently
- State updates don't follow same pattern

## React-Specific Examples

### ❌ Violating LSP - Breaking Component Contracts

The `EmailInput` and `NumberInput` components in our reference application violate LSP:

**Location**: `frontend/reference-application/React/src/components/EmailInput.tsx` and `NumberInput.tsx`

#### Base Input Component (Defines Contract)

```typescript
// Input.tsx - Base component defining the contract
export interface InputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  className?: string;
}

export const Input: React.FC<InputProps> = ({ value, onChange, placeholder, className }) => {
  // Contract: onChange is called for EVERY input change
  return (
    <input
      type="text"
      value={value}
      onChange={(e) => onChange(e.target.value)}
      placeholder={placeholder}
      className={className}
    />
  );
};
```

#### Violating EmailInput

```typescript
// EmailInput.tsx - VIOLATES LSP
// This component breaks the contract by not always calling onChange
export const EmailInput: React.FC<InputProps> = ({ value, onChange, placeholder }) => {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value.toLowerCase();
    
    // VIOLATION: Doesn't call onChange for invalid input
    // This breaks the contract - base Input always calls onChange
    if (!newValue.includes('@') && newValue.length > 0) {
      // Silently ignores invalid input - violates LSP
      return;
    }
    
    // VIOLATION: Only calls onChange conditionally
    onChange(newValue);
  };

  return (
    <input
      type="email"
      value={value}
      onChange={handleChange}
      placeholder={placeholder || 'Enter email'}
    />
  );
};

// VIOLATION: Cannot be substituted for Input without breaking functionality
// VIOLATION: Changes the contract - doesn't always call onChange
// VIOLATION: Modifies input value (lowercase) without always notifying parent
```

**Problems:**
- ❌ Doesn't call `onChange` for invalid input (breaks contract)
- ❌ Cannot be used where `Input` is expected
- ❌ Tests written for `Input` fail with `EmailInput`
- ❌ Parent components can't track all input changes

#### Violating NumberInput

```typescript
// NumberInput.tsx - VIOLATES LSP
// This component breaks the contract by not always calling onChange
export const NumberInput: React.FC<InputProps> = ({ value, onChange, placeholder }) => {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const inputValue = e.target.value;
    
    // VIOLATION: Doesn't call onChange for non-numeric input
    // This breaks the contract - base Input always calls onChange
    if (inputValue !== '' && !/^\d*\.?\d*$/.test(inputValue)) {
      // Silently ignores invalid input - violates LSP
      return;
    }
    
    // VIOLATION: Only calls onChange conditionally
    onChange(inputValue);
  };

  return (
    <input
      type="text"
      inputMode="numeric"
      value={value}
      onChange={handleChange}
      placeholder={placeholder || 'Enter number'}
    />
  );
};
```

### ✅ Refactored - Applying LSP

Here's how to fix the components to honor the contract:

#### LSP-Compliant EmailInput

```typescript
// EmailInput.tsx - LSP-Compliant
// Always calls onChange, maintains contract
export const EmailInput: React.FC<InputProps> = ({ value, onChange, placeholder }) => {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value.toLowerCase();
    
    // Always calls onChange - maintains contract
    // Validation can be done in parent or via separate validation prop
    onChange(newValue);
  };

  const isValid = value.includes('@') || value.length === 0;

  return (
    <div className="email-input-wrapper">
      <input
        type="email"
        value={value}
        onChange={handleChange}
        placeholder={placeholder || 'Enter email'}
        className={isValid ? '' : 'invalid'}
      />
      {!isValid && value.length > 0 && (
        <span className="error-message">Please enter a valid email</span>
      )}
    </div>
  );
};

// Now can be substituted for Input without breaking functionality
// Always calls onChange - maintains contract
// Validation is visual, not behavioral
```

#### LSP-Compliant NumberInput

```typescript
// NumberInput.tsx - LSP-Compliant
// Always calls onChange, maintains contract
export const NumberInput: React.FC<InputProps> = ({ value, onChange, placeholder }) => {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const inputValue = e.target.value;
    
    // Always calls onChange - maintains contract
    // Filtering can be done, but parent is always notified
    onChange(inputValue);
  };

  const isValid = value === '' || /^\d*\.?\d*$/.test(value);

  return (
    <div className="number-input-wrapper">
      <input
        type="text"
        inputMode="numeric"
        value={value}
        onChange={handleChange}
        placeholder={placeholder || 'Enter number'}
        className={isValid ? '' : 'invalid'}
      />
      {!isValid && (
        <span className="error-message">Please enter a valid number</span>
      )}
    </div>
  );
};

// Now can be substituted for Input without breaking functionality
// Always calls onChange - maintains contract
// Validation is visual, not behavioral
```

**Benefits:**
- ✅ Always calls `onChange` (honors contract)
- ✅ Can be used where `Input` is expected
- ✅ Tests written for `Input` work with extended components
- ✅ Parent components can track all input changes

### Alternative: Validation via Props

If you need validation, add it as a separate concern:

```typescript
// Input with validation support (still LSP-compliant)
interface ValidatedInputProps extends InputProps {
  validator?: (value: string) => boolean;
  showValidation?: boolean;
}

export const ValidatedInput: React.FC<ValidatedInputProps> = ({
  value,
  onChange,
  validator,
  showValidation = true,
  ...props
}) => {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value;
    // Always calls onChange - maintains contract
    onChange(newValue);
  };

  const isValid = !validator || validator(value);

  return (
    <div className="validated-input-wrapper">
      <input
        {...props}
        value={value}
        onChange={handleChange}
        className={isValid ? '' : 'invalid'}
      />
      {showValidation && !isValid && (
        <span className="error-message">Invalid input</span>
      )}
    </div>
  );
};

// Usage - still maintains contract
<ValidatedInput
  value={email}
  onChange={setEmail}
  validator={(val) => val.includes('@')}
/>
```

## How to Apply LSP in React

### 1. Honor Props Contracts

**What it means**: Extended components should accept the same props as base components.

**How to do it**:
- Extend base props interface, don't replace it
- Don't make required props optional (unless base allows it)
- Don't change callback signatures
- Maintain same prop types

**Example**:
```typescript
// Base contract
interface BaseProps {
  value: string;
  onChange: (value: string) => void;
}

// LSP-Compliant extension
interface ExtendedProps extends BaseProps {
  additionalProp?: string; // Can add optional props
}

// Violates LSP
interface BadProps {
  value: string;
  onValueChange: (value: string) => void; // Changed callback name
}
```

### 2. Maintain Callback Behavior

**What it means**: Callbacks should be called with the same frequency and conditions.

**How to do it**:
- Always call callbacks when base component would
- Don't skip callback calls
- Don't change callback parameters
- Maintain same timing

**Example**:
```typescript
// Base: Always calls onChange
onChange(e.target.value);

// LSP-Compliant: Also always calls onChange
onChange(e.target.value.toLowerCase());

// Violates LSP: Conditionally calls onChange
if (isValid) {
  onChange(e.target.value); // Doesn't always call
}
```

### 3. Preserve Component Behavior

**What it means**: Extended components should behave like base components.

**How to do it**:
- Maintain same rendering behavior
- Preserve same state management patterns
- Keep same side effect behavior
- Maintain same accessibility features

### 4. Use Composition for Behavior Changes

**What it means**: If you need different behavior, use composition instead of breaking contracts.

**How to do it**:
- Wrap components instead of extending
- Use render props for behavior customization
- Use HOCs for cross-cutting concerns
- Keep base component contract intact

**Example**:
```typescript
// Instead of breaking contract, use composition
const EmailInputWrapper: React.FC<InputProps> = (props) => {
  const [isValid, setIsValid] = useState(true);
  
  const handleChange = (value: string) => {
    setIsValid(value.includes('@'));
    // Always call parent onChange - maintains contract
    props.onChange(value);
  };
  
  return (
    <div>
      <Input {...props} onChange={handleChange} />
      {!isValid && <span>Invalid email</span>}
    </div>
  );
};
```

## React Component Contracts

### Props Interfaces as Contracts

Props interfaces define contracts that must be honored:

```typescript
// Contract definition
interface ButtonProps {
  onClick: () => void;
  disabled?: boolean;
  children: React.ReactNode;
}

// LSP-Compliant: Honors contract
const PrimaryButton: React.FC<ButtonProps> = ({ onClick, disabled, children }) => (
  <button onClick={onClick} disabled={disabled} className="primary">
    {children}
  </button>
);

// Violates LSP: Changes contract
const BadButton: React.FC<ButtonProps> = ({ onClick, disabled, children }) => {
  // Violation: Doesn't call onClick when disabled
  const handleClick = () => {
    if (!disabled) {
      onClick(); // Should always be callable per contract
    }
  };
  return <button onClick={handleClick} disabled={disabled}>{children}</button>;
};
```

### Polymorphic Components

Components that can be used interchangeably:

```typescript
// Base component
const Input: React.FC<InputProps> = (props) => <input {...props} />;

// LSP-Compliant: Can be used anywhere Input is expected
const EmailInput: React.FC<InputProps> = (props) => (
  <input {...props} type="email" />
);

// Usage - both work the same way
<Input value={value} onChange={setValue} />
<EmailInput value={value} onChange={setValue} /> // Substitutable
```

## Exercise: Fix Component Substitutability

### Objective

Fix components in the reference application that violate LSP by breaking component contracts.

### Task

1. **Identify Contract Violations**:
   - Open `frontend/reference-application/React/src/components/EmailInput.tsx`
   - Open `frontend/reference-application/React/src/components/NumberInput.tsx`
   - Identify how they break the base `Input` contract

2. **Fix EmailInput**:
   - Make it always call `onChange` (even for invalid input)
   - Move validation to visual feedback only
   - Ensure it can be substituted for `Input`

3. **Fix NumberInput**:
   - Make it always call `onChange` (even for non-numeric input)
   - Move validation to visual feedback only
   - Ensure it can be substituted for `Input`

4. **Update Tests**:
   - Update tests to verify contract compliance
   - Test that extended components can substitute base components
   - Ensure all tests pass

### Deliverables

- LSP-compliant EmailInput component
- LSP-compliant NumberInput component
- Updated tests verifying substitutability
- Brief explanation of contract compliance

### Success Criteria

- ✅ Extended components always call onChange
- ✅ Extended components can be used where base Input is expected
- ✅ Tests written for Input work with extended components
- ✅ No breaking changes to component behavior

### Getting Started

1. Navigate to the reference application:
   ```bash
   cd frontend/reference-application/React
   ```

2. Review the base Input component contract

3. Fix EmailInput to honor the contract

4. Fix NumberInput to honor the contract

5. Update and run tests

---

**Previous**: [Open/Closed Principle](../2-Open-closed-principle/README.md)  
**Next**: [Interface Segregation Principle](../4-Interface-segregation-principle/README.md)
