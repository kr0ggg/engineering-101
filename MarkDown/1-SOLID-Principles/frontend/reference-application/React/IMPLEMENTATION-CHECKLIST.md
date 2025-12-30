# React Reference Application - Implementation Checklist

## Phase 1: Project Setup ✅

- [ ] Create `package.json` with dependencies
- [ ] Create `tsconfig.json` for TypeScript
- [ ] Create `vite.config.ts` (or similar build config)
- [ ] Create `.gitignore`
- [ ] Create `README.md`
- [ ] Create `build-and-test.sh` script

## Phase 2: Core Application Structure

### Types & Interfaces
- [ ] Create `src/types/index.ts` with:
  - [ ] `Product` interface
  - [ ] `CartItem` interface
  - [ ] `User` interface
  - [ ] `Order` interface
  - [ ] `AdminAction` interface

### Services (Violating DIP)
- [ ] Create `src/services/api.ts`:
  - [ ] Direct `fetch()` calls (violation)
  - [ ] Hard-coded endpoints (violation)
  - [ ] `getProducts()` function
  - [ ] `getUser()` function
  - [ ] `getOrders()` function

### Hooks (Violating DIP)
- [ ] Create `src/hooks/useProductData.ts`:
  - [ ] Direct dependency on `api.ts` (violation)
  - [ ] No abstraction (violation)

## Phase 3: Components (Violating SOLID)

### SRP Violations
- [ ] Create `src/components/ProductDashboard.tsx`:
  - [ ] Data fetching logic
  - [ ] Filtering logic
  - [ ] Sorting logic
  - [ ] Cart management
  - [ ] UI rendering
  - [ ] Error handling
  - [ ] Loading state

### OCP Violations
- [ ] Create `src/components/Button.tsx`:
  - [ ] Hard-coded styles
  - [ ] Hard-coded behavior
  - [ ] No extension points

- [ ] Create `src/components/ProductList.tsx`:
  - [ ] Hard-coded layout
  - [ ] Hard-coded styling
  - [ ] Cannot be extended

### LSP Violations
- [ ] Create `src/components/Input.tsx` (base):
  - [ ] Standard input component
  - [ ] Defines contract via props

- [ ] Create `src/components/EmailInput.tsx`:
  - [ ] Violates LSP - changes behavior
  - [ ] Doesn't honor base contract

- [ ] Create `src/components/NumberInput.tsx`:
  - [ ] Violates LSP - breaks contract

### ISP Violations
- [ ] Create `src/components/UserProfile.tsx`:
  - [ ] Fat props interface
  - [ ] Display props
  - [ ] Edit props
  - [ ] Admin props
  - [ ] Analytics props

### DIP Violations (Already in services/hooks)
- [ ] Verify direct dependencies in components
- [ ] Verify no abstractions

## Phase 4: Main App

- [ ] Create `src/App.tsx`:
  - [ ] Routes setup
  - [ ] Component composition
  - [ ] Uses violating components

## Phase 5: Tests

### Component Tests
- [ ] `ProductDashboard.test.tsx`:
  - [ ] Tests data fetching
  - [ ] Tests filtering
  - [ ] Tests sorting
  - [ ] Tests cart management

- [ ] `UserProfile.test.tsx`:
  - [ ] Tests display
  - [ ] Tests edit functionality
  - [ ] Tests admin panel

- [ ] `Button.test.tsx`:
  - [ ] Tests basic rendering
  - [ ] Tests click handler

- [ ] `Input.test.tsx`:
  - [ ] Tests base input
  - [ ] Tests EmailInput
  - [ ] Tests NumberInput

### Hook Tests
- [ ] `useProductData.test.ts`:
  - [ ] Tests data fetching
  - [ ] Tests error handling

## Phase 6: Documentation

- [ ] Update `README.md` with:
  - [ ] Setup instructions
  - [ ] Violation descriptions
  - [ ] Exercise instructions

- [ ] Create inline code comments:
  - [ ] Mark all violations clearly
  - [ ] Explain what violates which principle

## Phase 7: Build & Test Scripts

- [ ] Create `build-and-test.sh`:
  - [ ] Install dependencies
  - [ ] Run linter
  - [ ] Run type check
  - [ ] Run tests
  - [ ] Build application

- [ ] Verify all scripts work

## Phase 8: Code Examples for Documentation

- [ ] Extract code examples for:
  - [ ] SRP violation example
  - [ ] SRP refactored example
  - [ ] OCP violation example
  - [ ] OCP refactored example
  - [ ] LSP violation example
  - [ ] LSP refactored example
  - [ ] ISP violation example
  - [ ] ISP refactored example
  - [ ] DIP violation example
  - [ ] DIP refactored example

## Phase 9: Review & Refinement

- [ ] Code review all violations
- [ ] Ensure violations are clear and intentional
- [ ] Verify tests work correctly
- [ ] Check that refactoring is possible
- [ ] Ensure examples are realistic

## Phase 10: Integration

- [ ] Link from main SOLID principles README
- [ ] Update course workflow document
- [ ] Create React-specific learning path
- [ ] Add to main course index

---

## File Structure to Create

```
React/
├── package.json
├── tsconfig.json
├── vite.config.ts
├── .gitignore
├── .eslintrc.json
├── jest.config.js
├── README.md
├── IMPLEMENTATION-CHECKLIST.md
├── build-and-test.sh
├── public/
│   └── index.html
└── src/
    ├── main.tsx
    ├── App.tsx
    ├── components/
    │   ├── ProductDashboard.tsx
    │   ├── UserProfile.tsx
    │   ├── ProductList.tsx
    │   ├── Button.tsx
    │   ├── Input.tsx
    │   ├── EmailInput.tsx
    │   └── NumberInput.tsx
    ├── hooks/
    │   └── useProductData.ts
    ├── services/
    │   └── api.ts
    ├── types/
    │   └── index.ts
    └── tests/
        ├── components/
        │   ├── ProductDashboard.test.tsx
        │   ├── UserProfile.test.tsx
        │   ├── Button.test.tsx
        │   └── Input.test.tsx
        └── hooks/
            └── useProductData.test.ts
```

---

## Dependencies to Include

```json
{
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "@typescript-eslint/eslint-plugin": "^5.0.0",
    "@typescript-eslint/parser": "^5.0.0",
    "@vitejs/plugin-react": "^3.1.0",
    "@testing-library/react": "^13.4.0",
    "@testing-library/jest-dom": "^5.16.0",
    "@testing-library/user-event": "^14.0.0",
    "eslint": "^8.0.0",
    "eslint-plugin-react": "^7.32.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "jest": "^29.0.0",
    "jest-environment-jsdom": "^29.0.0",
    "typescript": "^5.0.0",
    "vite": "^4.0.0"
  }
}
```

---

## Notes

- Start with basic structure
- Add violations incrementally
- Test as you go
- Keep violations clear and intentional
- Make refactoring path obvious

