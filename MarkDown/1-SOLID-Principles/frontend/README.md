# SOLID Principles: Frontend Development Track

## Overview

This track focuses on applying SOLID principles to **frontend development** with React.js and TypeScript. You'll learn how to write clean, maintainable code for Single Page Applications (SPAs).

## Target Audience

- Frontend developers
- React.js engineers
- TypeScript developers
- UI/UX engineers building SPAs

## Technologies Covered

This track uses modern frontend technologies:

- **React 18+**: Latest React features and patterns
- **TypeScript**: Type-safe React development
- **React Hooks**: Custom hooks for logic separation
- **Component Composition**: Building complex UIs from simple components
- **Modern React Patterns**: Best practices for React development

## Reference Application

The frontend reference application is an **E-commerce Product Management Dashboard** built with React and TypeScript. It demonstrates SOLID principles through real-world React components.

### Application Features

- Product listing with search, filtering, and sorting
- Shopping cart management
- User profile display and editing
- Order history
- Admin panel (for admin users)

### Architecture

The application includes React components that intentionally violate SOLID principles. Your exercises will involve refactoring these components to follow SOLID principles while maintaining functionality.

**Location**: [`reference-application/React/`](./reference-application/React/README.md)

## The Five SOLID Principles in React

### 1. [Single Responsibility Principle](./1-Single-class-reponsibility-principle/README.md)
**Goal**: Each component/hook should have only one purpose.

**React Focus**:
- Separating data fetching from rendering
- Isolating business logic in custom hooks
- Creating focused, single-purpose components
- Extracting UI logic into separate components

**Exercise**: Refactor `ProductDashboard` component that handles data fetching, filtering, sorting, cart management, and rendering into focused components and hooks.

### 2. [Open/Closed Principle](./2-Open-closed-principle/README.md)
**Goal**: Components should be open for extension but closed for modification.

**React Focus**:
- Extensible via props and composition
- Using `children` prop for composition
- Render props pattern
- Higher-order components (HOCs)
- Compound components

**Exercise**: Make hard-coded components extensible via props and composition without modifying their source code.

### 3. [Liskov Substitution Principle](./3-Liskov-substitution-principle/README.md)
**Goal**: Extended components should be substitutable for base components.

**React Focus**:
- Consistent prop interfaces
- Polymorphic components
- Maintaining component contracts
- Proper component inheritance (when used)

**Exercise**: Fix components that break their base component contracts, ensuring they can be used interchangeably.

### 4. [Interface Segregation Principle](./4-Interface-segregation-principle/README.md)
**Goal**: Components should not be forced to depend on props they don't use.

**React Focus**:
- Minimal, focused prop interfaces
- Optional props for non-essential features
- Component composition over fat interfaces
- Specialized components for specific use cases

**Exercise**: Segregate fat prop interfaces into focused, minimal interfaces and create specialized components.

### 5. [Dependency Inversion Principle](./5-Dependency-segregation-principle/README.md)
**Goal**: Components should depend on abstractions, not concrete implementations.

**React Focus**:
- Service abstractions
- Dependency injection via props or context
- Abstracting API calls
- Mockable dependencies for testing

**Exercise**: Refactor components to depend on service interfaces rather than concrete API implementations.

## Prerequisites

Before starting this track, you should have:

- **Basic understanding of React** (components, props, state)
- **Familiarity with TypeScript** (interfaces, types)
- **Understanding of React Hooks** (useState, useEffect, custom hooks)
- **Basic knowledge of unit testing** (Jest, React Testing Library)

## Setup Instructions

### 1. Install Prerequisites

- **Node.js 18+** and npm
- **Git** for version control

### 2. Set Up the Reference Application

Navigate to the React reference application:

```bash
cd frontend/reference-application/React
```

### 3. Install Dependencies

```bash
npm install
```

### 4. Run Development Server

```bash
npm run dev
```

### 5. Run Tests

```bash
npm test
```

All tests should pass initially (they test the violating code).

## Working Through the Exercises

### Development Workflow

1. **Create a Branch**: Start by creating a new branch for your work
   ```bash
   git checkout -b your-name/react-solid-exercise
   ```

2. **Work on Your Branch**: Make all your changes on your personal branch

3. **Commit Frequently**: Check in your work often with meaningful commit messages

4. **Run Tests Regularly**: Execute tests frequently to ensure your refactoring maintains functionality

5. **Refactor Incrementally**: Apply one principle at a time, testing after each change

### Exercise Structure

Each principle has:
- **Theory Section**: Understanding the principle in React context
- **Violation Examples**: React components that violate the principle
- **Refactored Examples**: SOLID-compliant React code
- **Hands-on Exercise**: Refactor the reference application
- **Success Criteria**: How to know you've succeeded

## React-Specific Patterns

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
├── useProducts.ts          # Data fetching (SRP, DIP)
├── useProductFilter.ts     # Filtering (SRP)
├── useProductSort.ts      # Sorting (SRP)
└── useCart.ts             # Cart management (SRP)
```

### Service Organization
```
services/
├── ProductService.ts      # Interface (DIP)
├── ApiProductService.ts   # Implementation (DIP)
└── MockProductService.ts  # Test implementation (DIP)
```

## Learning Path

Work through the principles in order:

1. **Single Responsibility Principle** → Start here
2. **Open/Closed Principle** → Builds on SRP
3. **Liskov Substitution Principle** → Builds on OCP
4. **Interface Segregation Principle** → Builds on LSP
5. **Dependency Inversion Principle** → Builds on ISP

Each principle builds upon the previous ones, creating a comprehensive approach to clean React code.

## Success Criteria

After completing all exercises, you should be able to:

- ✅ Identify SOLID principle violations in React code
- ✅ Refactor React components to follow SOLID principles
- ✅ Design clean, maintainable React components
- ✅ Write testable React code with proper abstractions
- ✅ Apply SOLID principles to your own React projects

## Additional Resources

- **Reference Application**: [`reference-application/React/README.md`](./reference-application/React/README.md)
- **Quick Reference**: [`REACT-SOLID-QUICK-REFERENCE.md`](./REACT-SOLID-QUICK-REFERENCE.md)
- **Implementation Plan**: [`REACT-ADDITIONS-PLAN.md`](./REACT-ADDITIONS-PLAN.md)
- **Main Course Overview**: [`../0-README.md`](../0-README.md)
- **Backend Track**: [`../backend/README.md`](../backend/README.md) (for comparison)

---

**Ready to begin?** Start with the [Single Responsibility Principle](./1-Single-class-reponsibility-principle/README.md)!

