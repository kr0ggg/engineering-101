# TypeScript Testing Setup Guide

## Overview

This guide walks you through setting up a complete testing environment for TypeScript (Node.js) backend development using Jest and Testcontainers.

## Prerequisites

- **Node.js 18 or later**
  - Download: https://nodejs.org/
  - Verify: `node --version`

- **npm or yarn**
  - npm comes with Node.js
  - Verify: `npm --version`

- **IDE** (choose one):
  - VS Code (recommended for TypeScript)
  - WebStorm
  - Sublime Text with TypeScript plugin

- **Docker Desktop** (for integration tests)
  - Download: https://docs.docker.com/get-docker/
  - Required for Testcontainers

## Project Structure

```
ecommerce-app/
├── src/
│   ├── services/
│   ├── repositories/
│   └── models/
├── tests/
│   ├── services/
│   ├── repositories/
│   ├── integration/
│   └── helpers/
├── package.json
├── tsconfig.json
└── jest.config.js
```

## Step 1: Initialize Project

```bash
# Create project directory
mkdir ecommerce-app
cd ecommerce-app

# Initialize npm project
npm init -y

# Install TypeScript
npm install --save-dev typescript @types/node

# Create tsconfig.json
npx tsc --init
```

## Step 2: Install Testing Packages

```bash
# Jest and TypeScript support
npm install --save-dev jest ts-jest @types/jest

# Testing utilities
npm install --save-dev @jest/globals

# Testcontainers
npm install --save-dev testcontainers

# PostgreSQL driver
npm install pg
npm install --save-dev @types/pg
```

Update `package.json`:

```json
{
  "name": "ecommerce-app",
  "version": "1.0.0",
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "test:integration": "jest --testMatch='**/*.integration.test.ts'",
    "build": "tsc",
    "start": "node dist/index.js"
  },
  "devDependencies": {
    "@jest/globals": "^29.7.0",
    "@types/jest": "^29.5.11",
    "@types/node": "^20.10.6",
    "@types/pg": "^8.10.9",
    "jest": "^29.7.0",
    "testcontainers": "^10.4.0",
    "ts-jest": "^29.1.1",
    "typescript": "^5.3.3"
  },
  "dependencies": {
    "pg": "^8.11.3"
  }
}
```

## Step 3: Configure TypeScript

Update `tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "types": ["node", "jest"]
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "tests"]
}
```

## Step 4: Configure Jest

Create `jest.config.js`:

```javascript
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/tests'],
  testMatch: ['**/*.test.ts'],
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/**/*.interface.ts'
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  },
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1'
  },
  setupFilesAfterEnv: ['<rootDir>/tests/setup.ts'],
  verbose: true
};
```

Create `tests/setup.ts`:

```typescript
// Global test setup
beforeAll(() => {
  // Setup code that runs once before all tests
});

afterAll(() => {
  // Cleanup code that runs once after all tests
});
```

## Step 5: Write Your First Test

Create `tests/services/CustomerService.test.ts`:

```typescript
import { describe, it, expect, jest, beforeEach } from '@jest/globals';
import { CustomerService } from '../../src/services/CustomerService';
import { CustomerRepository } from '../../src/repositories/CustomerRepository';
import { Customer } from '../../src/models/Customer';

describe('CustomerService', () => {
  let mockRepository: jest.Mocked<CustomerRepository>;
  let service: CustomerService;

  beforeEach(() => {
    mockRepository = {
      save: jest.fn(),
      findById: jest.fn(),
      findByEmail: jest.fn(),
      delete: jest.fn(),
    } as jest.Mocked<CustomerRepository>;

    service = new CustomerService(mockRepository);
  });

  describe('createCustomer', () => {
    it('should save customer to repository', async () => {
      // Arrange
      const customer: Customer = {
        id: 1,
        name: 'John Doe',
        email: 'john@example.com',
        isActive: true,
      };

      // Act
      await service.createCustomer(customer);

      // Assert
      expect(mockRepository.save).toHaveBeenCalledWith(
        expect.objectContaining({
          name: 'John Doe',
          email: 'john@example.com',
        })
      );
      expect(mockRepository.save).toHaveBeenCalledTimes(1);
    });

    it.each([
      ['', 'john@example.com'],
      [null, 'john@example.com'],
      ['   ', 'john@example.com'],
    ])('should throw error when name is invalid: "%s"', async (invalidName, email) => {
      // Arrange
      const customer: Customer = {
        id: 1,
        name: invalidName as string,
        email,
        isActive: true,
      };

      // Act & Assert
      await expect(service.createCustomer(customer)).rejects.toThrow('Name is required');
    });
  });

  describe('getCustomer', () => {
    it('should return customer when exists', async () => {
      // Arrange
      const expected: Customer = {
        id: 1,
        name: 'John Doe',
        email: 'john@example.com',
        isActive: true,
      };
      mockRepository.findById.mockResolvedValue(expected);

      // Act
      const result = await service.getCustomer(1);

      // Assert
      expect(result).toBeDefined();
      expect(result?.name).toBe('John Doe');
      expect(result?.email).toBe('john@example.com');
    });

    it('should return null when customer not found', async () => {
      // Arrange
      mockRepository.findById.mockResolvedValue(null);

      // Act
      const result = await service.getCustomer(999);

      // Assert
      expect(result).toBeNull();
    });
  });
});
```

## Step 6: Run Tests

```bash
# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Run in watch mode
npm run test:watch

# Run specific test file
npm test -- CustomerService.test.ts

# Run tests matching pattern
npm test -- --testNamePattern="should save"

# Run only integration tests
npm run test:integration

# Run with verbose output
npm test -- --verbose

# Update snapshots
npm test -- --updateSnapshot
```

## Step 7: Configure Test Helpers

### Test Base Class

```typescript
// tests/helpers/TestBase.ts
export abstract class TestBase {
  beforeEach(): void {
    // Common setup
  }

  afterEach(): void {
    // Common cleanup
  }
}
```

### Test Data Builders

```typescript
// tests/helpers/CustomerBuilder.ts
import { Customer } from '../../src/models/Customer';

export class CustomerBuilder {
  private id = 1;
  private name = 'John Doe';
  private email = 'john@example.com';
  private isActive = true;

  withId(id: number): this {
    this.id = id;
    return this;
  }

  withName(name: string): this {
    this.name = name;
    return this;
  }

  withEmail(email: string): this {
    this.email = email;
    return this;
  }

  inactive(): this {
    this.isActive = false;
    return this;
  }

  build(): Customer {
    return {
      id: this.id,
      name: this.name,
      email: this.email,
      isActive: this.isActive,
    };
  }
}
```

Usage:

```typescript
it('should fail when customer is inactive', async () => {
  const customer = new CustomerBuilder()
    .withId(1)
    .inactive()
    .build();

  await expect(service.processOrder(customer, order)).rejects.toThrow();
});
```

### Mock Factories

```typescript
// tests/helpers/mockFactories.ts
import { jest } from '@jest/globals';
import { CustomerRepository } from '../../src/repositories/CustomerRepository';

export function createMockCustomerRepository(): jest.Mocked<CustomerRepository> {
  return {
    save: jest.fn(),
    findById: jest.fn(),
    findByEmail: jest.fn(),
    delete: jest.fn(),
  } as jest.Mocked<CustomerRepository>;
}
```

## Step 8: Integration Test Setup

### Testcontainers Configuration

```typescript
// tests/integration/DatabaseTestBase.ts
import { GenericContainer, StartedTestContainer } from 'testcontainers';
import { Pool } from 'pg';

export class DatabaseTestBase {
  protected static container: StartedTestContainer;
  protected static pool: Pool;

  static async setupDatabase(): Promise<void> {
    this.container = await new GenericContainer('postgres:16')
      .withEnvironment({
        POSTGRES_DB: 'ecommerce_test',
        POSTGRES_USER: 'test',
        POSTGRES_PASSWORD: 'test',
      })
      .withExposedPorts(5432)
      .start();

    this.pool = new Pool({
      host: this.container.getHost(),
      port: this.container.getMappedPort(5432),
      database: 'ecommerce_test',
      user: 'test',
      password: 'test',
    });

    await this.runMigrations();
  }

  static async teardownDatabase(): Promise<void> {
    await this.pool.end();
    await this.container.stop();
  }

  private static async runMigrations(): Promise<void> {
    const client = await this.pool.connect();
    try {
      await client.query(`
        CREATE TABLE customers (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          email VARCHAR(255) NOT NULL UNIQUE,
          is_active BOOLEAN DEFAULT true,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      `);
    } finally {
      client.release();
    }
  }
}
```

### Integration Test Example

```typescript
// tests/integration/CustomerRepository.integration.test.ts
import { describe, it, expect, beforeAll, afterAll } from '@jest/globals';
import { DatabaseTestBase } from './DatabaseTestBase';
import { CustomerRepository } from '../../src/repositories/CustomerRepository';
import { Customer } from '../../src/models/Customer';

describe('CustomerRepository Integration Tests', () => {
  beforeAll(async () => {
    await DatabaseTestBase.setupDatabase();
  });

  afterAll(async () => {
    await DatabaseTestBase.teardownDatabase();
  });

  it('should persist customer to database', async () => {
    // Arrange
    const repository = new CustomerRepository(DatabaseTestBase.pool);
    const customer: Customer = {
      id: 0,
      name: 'John Doe',
      email: 'john@example.com',
      isActive: true,
    };

    // Act
    await repository.save(customer);

    // Assert
    const retrieved = await repository.findByEmail('john@example.com');
    expect(retrieved).toBeDefined();
    expect(retrieved?.name).toBe('John Doe');
    expect(retrieved?.email).toBe('john@example.com');
  });

  it('should return null when customer not found', async () => {
    // Arrange
    const repository = new CustomerRepository(DatabaseTestBase.pool);

    // Act
    const result = await repository.findById(999);

    // Assert
    expect(result).toBeNull();
  });
});
```

## Step 9: Continuous Integration

### GitHub Actions

Create `.github/workflows/typescript-tests.yml`:

```yaml
name: TypeScript Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run tests
      run: npm run test:coverage
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        files: ./coverage/lcov.info
```

## Troubleshooting

### Issue: Tests Not Found

**Solution**: Ensure test files match pattern in `jest.config.js`:

```javascript
// jest.config.js
testMatch: ['**/*.test.ts']
```

### Issue: TypeScript Errors in Tests

**Solution**: Ensure Jest is configured for TypeScript:

```javascript
// jest.config.js
preset: 'ts-jest',
```

### Issue: Module Not Found

**Solution**: Configure path mapping:

```javascript
// jest.config.js
moduleNameMapper: {
  '^@/(.*)$': '<rootDir>/src/$1'
}
```

### Issue: Testcontainers Not Starting

**Solution**: Ensure Docker is running:

```bash
docker ps
```

### Issue: Slow Tests

**Solution**: Run tests in parallel:

```bash
npm test -- --maxWorkers=4
```

## Best Practices

### ✅ Do's

- Use `describe` and `it` for test organization
- Use `beforeEach` for test setup
- Use async/await for async tests
- Use type-safe mocks
- Keep tests independent

### ❌ Don'ts

- Don't test private methods directly
- Don't share state between tests
- Don't use `setTimeout` in tests
- Don't ignore failing tests
- Don't test framework code

## Quick Reference

### Common Commands

```bash
npm test                    # Run all tests
npm test -- --watch         # Watch mode
npm test -- --coverage      # With coverage
npm test -- file.test.ts    # Specific file
npm test -- --testNamePattern="pattern"  # Pattern match
```

### Common Jest Matchers

```typescript
expect(value).toBe(expected);
expect(value).toEqual(expected);
expect(value).toBeDefined();
expect(value).toBeNull();
expect(array).toHaveLength(3);
expect(array).toContain(item);
expect(fn).toThrow();
expect(fn).toHaveBeenCalled();
expect(fn).toHaveBeenCalledWith(arg);
```

### Common Mock Patterns

```typescript
// Mock function
const mockFn = jest.fn();
mockFn.mockReturnValue(value);
mockFn.mockResolvedValue(value);
mockFn.mockRejectedValue(error);

// Mock implementation
mockFn.mockImplementation((arg) => arg * 2);

// Verify calls
expect(mockFn).toHaveBeenCalled();
expect(mockFn).toHaveBeenCalledWith(arg);
expect(mockFn).toHaveBeenCalledTimes(2);
```

## Next Steps

1. Review [TypeScript Testing Patterns](./01-TESTING-PATTERNS.md)
2. Learn [TypeScript Mocking with Jest](./02-MOCKING.md)
3. Explore [TypeScript Integration Testing](./03-INTEGRATION-TESTING.md)
4. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**You're now ready to write tests in TypeScript!** Start with simple unit tests and gradually move to more complex scenarios.
