# TypeScript Testing Guide for SOLID Principles

## Overview

Comprehensive testing resources for TypeScript (Node.js) backend development using Jest and Testcontainers.

## Testing Stack

- **Jest** - Test framework and mocking
- **ts-jest** - TypeScript support for Jest
- **Testcontainers** - Integration testing

## Guide Structure

1. **[Setup](./00-SETUP.md)** - Complete TypeScript testing environment setup
2. **[Testing Patterns](./01-TESTING-PATTERNS.md)** - SOLID principle testing patterns
3. **[Mocking with Jest](./02-MOCKING.md)** - Comprehensive Jest mocking guide
4. **[Integration Testing](./03-INTEGRATION-TESTING.md)** - Testcontainers integration

## Quick Start

```bash
# Install dependencies
npm install

# Run tests
npm test
npm run test:coverage
npm run test:watch

# Run integration tests
npm run test:integration
```

## Key Concepts

- Use `describe` and `it` for test organization
- Use `beforeEach` for test setup
- Use Jest's built-in mocking
- Use Testcontainers for real database testing
- Follow AAA pattern (Arrange-Act-Assert)
- Type-safe mocks with TypeScript

## Next Steps

1. Complete [Setup](./00-SETUP.md)
2. Learn [Testing Patterns](./01-TESTING-PATTERNS.md)
3. Master [Jest Mocking](./02-MOCKING.md)
4. Apply to [SOLID Workshops](../README.md#solid-principle-testing-workshops)
