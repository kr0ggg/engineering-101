# React Reference Application - SOLID Principles Violations

## Overview

This React.js/TypeScript application demonstrates **intentional violations** of SOLID principles. It serves as a learning tool for front-end engineers to practice refactoring React code to follow SOLID principles.

## Application: E-commerce Product Management Dashboard

A single-page application for managing products, shopping cart, and user profiles.

### Features

- **Product Management**: Browse, search, filter, and sort products
- **Shopping Cart**: Add/remove items, view cart total
- **User Profile**: View and edit user information
- **Order History**: View past orders
- **Admin Panel**: Manage products (admin users only)

## Technology Stack

- **React 18+** with TypeScript
- **Vite** for build tooling
- **React Router** for navigation
- **Jest + React Testing Library** for testing
- **CSS Modules** for styling

## Prerequisites

- Node.js 18+ and npm
- Basic knowledge of React and TypeScript

## Setup Instructions

1. **Install Dependencies**:
   ```bash
   cd MarkDown/1-SOLID-Principles/reference-application/React
   npm install
   ```

2. **Run Development Server**:
   ```bash
   npm run dev
   ```

3. **Run Tests**:
   ```bash
   npm test
   ```

4. **Build for Production**:
   ```bash
   npm run build
   ```

## Application Structure

```
src/
├── App.tsx                    # Main app component (violates multiple principles)
├── components/
│   ├── ProductDashboard.tsx  # VIOLATES SRP - does everything
│   ├── UserProfile.tsx       # VIOLATES ISP - fat props interface
│   ├── ProductList.tsx       # VIOLATES OCP - hard-coded, not extensible
│   ├── Button.tsx            # VIOLATES OCP - cannot extend
│   └── Input.tsx             # Base for LSP violations
├── hooks/
│   └── useProductData.ts     # VIOLATES DIP - direct API dependency
├── services/
│   └── api.ts                # VIOLATES DIP - concrete implementation
└── types/
    └── index.ts              # TypeScript type definitions
```

## SOLID Principle Violations

### 1. Single Responsibility Principle (SRP)

**Violation**: `ProductDashboard.tsx`
- Handles data fetching
- Manages filtering logic
- Manages sorting logic
- Manages cart state
- Renders UI
- Handles errors
- All in one component!

**Exercise**: Refactor into single-responsibility components and hooks.

### 2. Open/Closed Principle (OCP)

**Violation**: `Button.tsx`, `ProductList.tsx`
- Hard-coded styles and behavior
- Cannot be extended without modification
- No composition support

**Exercise**: Make components extensible via props and composition.

### 3. Liskov Substitution Principle (LSP)

**Violation**: `EmailInput.tsx`, `NumberInput.tsx`
- Don't honor base `Input` component contract
- Change expected behavior
- Break when substituted

**Exercise**: Fix components to be properly substitutable.

### 4. Interface Segregation Principle (ISP)

**Violation**: `UserProfile.tsx`
- Fat props interface with many responsibilities
- Components forced to accept unused props
- No separation of concerns

**Exercise**: Segregate into focused component interfaces.

### 5. Dependency Inversion Principle (DIP)

**Violation**: `useProductData.ts`, `api.ts`
- Direct dependency on `fetch()` API
- Hard-coded endpoints
- No abstraction layer
- Cannot be tested easily

**Exercise**: Create abstractions and inject dependencies.

## Working Through Exercises

1. **Start with SRP**: Refactor `ProductDashboard.tsx`
2. **Then OCP**: Make components extensible
3. **Then LSP**: Fix component substitutability
4. **Then ISP**: Segregate fat interfaces
5. **Finally DIP**: Abstract dependencies

## Testing

All components have corresponding test files. After refactoring:

- All existing tests should pass
- You may need to update tests to match new structure
- Add new tests for extracted components/hooks

## Running Tests

```bash
# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch

# Run tests with coverage
npm test -- --coverage
```

## Notes

- **All violations are intentional** - this is a learning exercise
- **Tests may need refactoring** as you apply SOLID principles
- **Focus on one principle at a time**
- **Keep functionality the same** - only improve structure

## Success Criteria

After completing all exercises:

- ✅ Each component has a single responsibility
- ✅ Components are extensible without modification
- ✅ Components are properly substitutable
- ✅ Props interfaces are focused and minimal
- ✅ Dependencies are abstracted and injectable
- ✅ All tests pass
- ✅ Code is maintainable and readable

