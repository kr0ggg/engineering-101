# React SOLID Principles - Learning Path

## Overview

This learning path guides you through applying SOLID principles to React.js/TypeScript development. Follow this path to build clean, maintainable React applications.

## Prerequisites

Before starting, ensure you have:
- ✅ Basic understanding of React (components, props, state, hooks)
- ✅ Familiarity with TypeScript (interfaces, types)
- ✅ Understanding of React Hooks (useState, useEffect, custom hooks)
- ✅ Basic knowledge of unit testing (Jest, React Testing Library)

## Learning Path

### Step 1: Understand the Foundation

**Read**: [Frontend Track Overview](./README.md)

**What you'll learn**:
- How SOLID principles apply to React
- Overview of the React reference application
- Setup instructions

**Time**: 15-20 minutes

---

### Step 2: Single Responsibility Principle (SRP)

**Read**: [Single Responsibility Principle - React Edition](./1-Single-class-reponsibility-principle/README.md)

**What you'll learn**:
- How to identify multiple responsibilities in React components
- Separating data fetching from rendering
- Creating focused custom hooks
- Component composition patterns

**Exercise**: Refactor `ProductDashboard` component
- **Location**: `frontend/reference-application/React/src/components/ProductDashboard.tsx`
- **Goal**: Break down mono-component into focused components and hooks
- **Deliverables**: Separated components, custom hooks, passing tests

**Time**: 2-3 hours

**Key Takeaways**:
- One component/hook = one responsibility
- Extract logic into custom hooks
- Split large components into smaller ones
- Use composition to combine responsibilities

---

### Step 3: Open/Closed Principle (OCP)

**Read**: [Open/Closed Principle - React Edition](./2-Open-closed-principle/README.md)

**What you'll learn**:
- Making components extensible via props
- Composition patterns (children, render props, HOCs)
- Creating extensible component interfaces
- Avoiding hard-coded values

**Exercise**: Make `Button` and `ProductList` extensible
- **Location**: `frontend/reference-application/React/src/components/Button.tsx` and `ProductList.tsx`
- **Goal**: Make components extensible without modifying source code
- **Deliverables**: Extensible components, extended variants, passing tests

**Time**: 2-3 hours

**Key Takeaways**:
- Use props for customization
- Support children prop for composition
- Use render props for flexible rendering
- Avoid hard-coded values

---

### Step 4: Liskov Substitution Principle (LSP)

**Read**: [Liskov Substitution Principle - React Edition](./3-Liskov-substitution-principle/README.md)

**What you'll learn**:
- Component contracts and prop interfaces
- Ensuring extended components honor contracts
- Maintaining consistent behavior
- Polymorphic components

**Exercise**: Fix `EmailInput` and `NumberInput` components
- **Location**: `frontend/reference-application/React/src/components/EmailInput.tsx` and `NumberInput.tsx`
- **Goal**: Make components properly substitutable for base `Input` component
- **Deliverables**: LSP-compliant components, passing tests

**Time**: 1-2 hours

**Key Takeaways**:
- Extended components must honor base contracts
- Always call callbacks as expected
- Maintain consistent behavior
- Use composition for behavior changes

---

### Step 5: Interface Segregation Principle (ISP)

**Read**: [Interface Segregation Principle - React Edition](./4-Interface-segregation-principle/README.md)

**What you'll learn**:
- Identifying fat props interfaces
- Creating focused, minimal prop interfaces
- Component specialization
- Composition over fat interfaces

**Exercise**: Segregate `UserProfile` props interface
- **Location**: `frontend/reference-application/React/src/components/UserProfile.tsx`
- **Goal**: Break down fat props interface into focused components
- **Deliverables**: Segregated components, minimal props, passing tests

**Time**: 2-3 hours

**Key Takeaways**:
- Components should only depend on props they use
- Create focused, minimal prop interfaces
- Use composition for complex features
- Specialize components for specific use cases

---

### Step 6: Dependency Inversion Principle (DIP)

**Read**: [Dependency Inversion Principle - React Edition](./5-Dependency-segregation-principle/README.md)

**What you'll learn**:
- Creating service abstractions
- Dependency injection in React
- Using context for dependency injection
- Testing with mock services

**Exercise**: Implement dependency inversion
- **Location**: `frontend/reference-application/React/src/hooks/useProductData.ts` and `src/services/api.ts`
- **Goal**: Refactor to depend on abstractions, not concrete implementations
- **Deliverables**: Service interfaces, dependency injection, passing tests

**Time**: 2-3 hours

**Key Takeaways**:
- Depend on interfaces, not implementations
- Inject dependencies via props or context
- Easy to test with mock services
- Can swap implementations easily

---

## Complete Learning Path Timeline

| Step | Principle | Time Estimate | Cumulative |
|------|-----------|---------------|------------|
| 1 | Foundation | 15-20 min | 20 min |
| 2 | SRP | 2-3 hours | 2.5-3.5 hours |
| 3 | OCP | 2-3 hours | 4.5-6.5 hours |
| 4 | LSP | 1-2 hours | 5.5-8.5 hours |
| 5 | ISP | 2-3 hours | 7.5-11.5 hours |
| 6 | DIP | 2-3 hours | 9.5-14.5 hours |

**Total Estimated Time**: 10-15 hours

## Quick Reference

### Common Patterns

**SRP - Component Extraction**:
```typescript
// Before: Mono-component
const Dashboard = () => { /* everything */ };

// After: Focused components
const Dashboard = () => (
  <>
    <SearchInput />
    <ProductList />
    <CartDisplay />
  </>
);
```

**OCP - Props Extension**:
```typescript
// Before: Hard-coded
<Button text="Click" />

// After: Extensible
<Button variant="primary" size="large" onClick={handleClick}>
  Click
</Button>
```

**LSP - Contract Compliance**:
```typescript
// Always call onChange
onChange(e.target.value); // Not conditionally
```

**ISP - Focused Props**:
```typescript
// Before: Fat interface
<UserProfile name={name} email={email} onEdit={...} isAdmin={...} />

// After: Focused components
<UserDisplay name={name} email={email} />
{canEdit && <UserEdit onEdit={...} />}
```

**DIP - Abstraction**:
```typescript
// Before: Direct dependency
const data = await fetch('/api/products');

// After: Abstracted
const data = await productService.getProducts();
```

## Resources

- **Quick Reference**: [REACT-SOLID-QUICK-REFERENCE.md](./REACT-SOLID-QUICK-REFERENCE.md)
- **Reference Application**: [reference-application/React/README.md](./reference-application/React/README.md)
- **Backend Track**: [../backend/README.md](../backend/README.md) (for comparison)

## Next Steps After Completion

1. **Apply to Your Projects**: Use these principles in your own React codebase
2. **Review Backend Track**: Compare React patterns with backend patterns
3. **Continue Learning**: Explore advanced React patterns and architecture
4. **Share Knowledge**: Teach others what you've learned

---

**Ready to begin?** Start with the [Frontend Track Overview](./README.md)!

