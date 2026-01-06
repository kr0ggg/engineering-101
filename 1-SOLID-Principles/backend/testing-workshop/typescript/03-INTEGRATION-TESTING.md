# TypeScript Integration Testing with Testcontainers

## Overview

Integration tests verify that multiple components work together correctly. This guide covers integration testing in TypeScript using Testcontainers for real database testing.

## Setup

```bash
npm install --save-dev testcontainers
npm install pg
npm install --save-dev @types/pg
```

## Basic Testcontainers Setup

### Database Test Base

```typescript
import { GenericContainer, StartedTestContainer } from 'testcontainers';
import { Pool, PoolClient } from 'pg';

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
        
        CREATE TABLE orders (
          id SERIAL PRIMARY KEY,
          customer_id INTEGER REFERENCES customers(id),
          total DECIMAL(10, 2) NOT NULL,
          status VARCHAR(50) NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      `);
    } finally {
      client.release();
    }
  }
}
```

### Repository Integration Test

```typescript
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

  it('should update existing customer', async () => {
    // Arrange
    const repository = new CustomerRepository(DatabaseTestBase.pool);
    const customer: Customer = {
      id: 0,
      name: 'John Doe',
      email: 'john2@example.com',
      isActive: true,
    };
    await repository.save(customer);

    // Act
    customer.name = 'Jane Doe';
    await repository.update(customer);

    // Assert
    const updated = await repository.findById(customer.id);
    expect(updated?.name).toBe('Jane Doe');
  });

  it('should delete customer', async () => {
    // Arrange
    const repository = new CustomerRepository(DatabaseTestBase.pool);
    const customer: Customer = {
      id: 0,
      name: 'John Doe',
      email: 'john3@example.com',
      isActive: true,
    };
    await repository.save(customer);

    // Act
    await repository.delete(customer.id);

    // Assert
    const deleted = await repository.findById(customer.id);
    expect(deleted).toBeNull();
  });
});
```

## Transaction Testing

```typescript
describe('Transaction Tests', () => {
  beforeAll(async () => {
    await DatabaseTestBase.setupDatabase();
  });

  afterAll(async () => {
    await DatabaseTestBase.teardownDatabase();
  });

  it('should rollback on error', async () => {
    // Arrange
    const client = await DatabaseTestBase.pool.connect();
    const repository = new CustomerRepository(DatabaseTestBase.pool);
    const customer: Customer = {
      id: 0,
      name: 'John Doe',
      email: 'john4@example.com',
      isActive: true,
    };

    try {
      await client.query('BEGIN');
      
      // Act
      await repository.save(customer);
      throw new Error('Simulated error');
    } catch (error) {
      await client.query('ROLLBACK');
    } finally {
      client.release();
    }

    // Assert - Customer should not exist
    const result = await repository.findByEmail('john4@example.com');
    expect(result).toBeNull();
  });

  it('should commit successfully', async () => {
    // Arrange
    const client = await DatabaseTestBase.pool.connect();
    const repository = new CustomerRepository(DatabaseTestBase.pool);
    const customer: Customer = {
      id: 0,
      name: 'John Doe',
      email: 'john5@example.com',
      isActive: true,
    };

    try {
      await client.query('BEGIN');
      
      // Act
      await repository.save(customer);
      await client.query('COMMIT');
    } finally {
      client.release();
    }

    // Assert - Customer should exist
    const result = await repository.findByEmail('john5@example.com');
    expect(result).toBeDefined();
  });
});
```

## Testing Multiple Containers

```typescript
import { GenericContainer } from 'testcontainers';

describe('Multi-Container Tests', () => {
  let postgresContainer: StartedTestContainer;
  let redisContainer: StartedTestContainer;

  beforeAll(async () => {
    [postgresContainer, redisContainer] = await Promise.all([
      new GenericContainer('postgres:16')
        .withEnvironment({ POSTGRES_PASSWORD: 'test' })
        .withExposedPorts(5432)
        .start(),
      new GenericContainer('redis:7')
        .withExposedPorts(6379)
        .start(),
    ]);
  });

  afterAll(async () => {
    await Promise.all([
      postgresContainer.stop(),
      redisContainer.stop(),
    ]);
  });

  it('should connect to both containers', () => {
    expect(postgresContainer.getMappedPort(5432)).toBeGreaterThan(0);
    expect(redisContainer.getMappedPort(6379)).toBeGreaterThan(0);
  });
});
```

## Performance Testing

```typescript
describe('Performance Tests', () => {
  beforeAll(async () => {
    await DatabaseTestBase.setupDatabase();
  });

  afterAll(async () => {
    await DatabaseTestBase.teardownDatabase();
  });

  it('should complete bulk insert in reasonable time', async () => {
    // Arrange
    const repository = new CustomerRepository(DatabaseTestBase.pool);
    const customers: Customer[] = Array.from({ length: 1000 }, (_, i) => ({
      id: 0,
      name: `Customer ${i}`,
      email: `customer${i}@example.com`,
      isActive: true,
    }));

    // Act
    const startTime = Date.now();
    for (const customer of customers) {
      await repository.save(customer);
    }
    const duration = Date.now() - startTime;

    // Assert
    expect(duration).toBeLessThan(5000); // 5 seconds
  });
});
```

## Data Seeding

```typescript
class DatabaseSeeder {
  constructor(private pool: Pool) {}

  async seedTestData(): Promise<void> {
    await this.seedCustomers();
    await this.seedProducts();
    await this.seedOrders();
  }

  private async seedCustomers(): Promise<void> {
    const client = await this.pool.connect();
    try {
      await client.query(`
        INSERT INTO customers (name, email, is_active)
        VALUES 
          ('John Doe', 'john@example.com', true),
          ('Jane Smith', 'jane@example.com', true),
          ('Bob Johnson', 'bob@example.com', false)
      `);
    } finally {
      client.release();
    }
  }

  private async seedProducts(): Promise<void> {
    // Seed products
  }

  private async seedOrders(): Promise<void> {
    // Seed orders
  }
}

// Usage in tests
describe('Seeded Database Tests', () => {
  beforeAll(async () => {
    await DatabaseTestBase.setupDatabase();
    const seeder = new DatabaseSeeder(DatabaseTestBase.pool);
    await seeder.seedTestData();
  });

  afterAll(async () => {
    await DatabaseTestBase.teardownDatabase();
  });

  it('should return only active customers', async () => {
    // Arrange
    const repository = new CustomerRepository(DatabaseTestBase.pool);

    // Act
    const customers = await repository.findActiveCustomers();

    // Assert
    expect(customers).toHaveLength(2);
    expect(customers.every(c => c.isActive)).toBe(true);
  });
});
```

## Cleanup Between Tests

```typescript
describe('Clean Database Tests', () => {
  beforeAll(async () => {
    await DatabaseTestBase.setupDatabase();
  });

  afterAll(async () => {
    await DatabaseTestBase.teardownDatabase();
  });

  afterEach(async () => {
    // Cleanup after each test
    const client = await DatabaseTestBase.pool.connect();
    try {
      await client.query('DELETE FROM orders');
      await client.query('DELETE FROM customers');
    } finally {
      client.release();
    }
  });

  it('test 1', async () => {
    // Test with clean database
  });

  it('test 2', async () => {
    // Starts with clean database
  });
});
```

## Best Practices

### ✅ Do's

```typescript
// Use beforeAll for container setup
beforeAll(async () => {
  await DatabaseTestBase.setupDatabase();
}, 60000); // Increase timeout for container startup

// Clean up after tests
afterEach(async () => {
  await cleanDatabase();
});

// Use transactions for isolation
const client = await pool.connect();
await client.query('BEGIN');
try {
  // Test code
  await client.query('COMMIT');
} catch (error) {
  await client.query('ROLLBACK');
  throw error;
} finally {
  client.release();
}

// Test realistic scenarios
it('should complete order workflow', async () => {
  // Test end-to-end workflow
});
```

### ❌ Don'ts

```typescript
// Don't share data between tests
let sharedCustomer: Customer; // Bad!

// Don't use production database
const pool = new Pool({ connectionString: 'production-url' }); // Never!

// Don't skip cleanup
// Always clean up test data

// Don't test too much in one test
it('should test everything', async () => { // Bad - too broad
  // 100 lines of test code
});
```

## Running Integration Tests

```bash
# Run all tests
npm test

# Run only integration tests
npm test -- --testMatch='**/*.integration.test.ts'

# Run with coverage
npm test -- --coverage

# Run with increased timeout
npm test -- --testTimeout=60000
```

## Configuration

### jest.config.js

```javascript
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  testMatch: ['**/*.test.ts'],
  testTimeout: 30000, // Increase for integration tests
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
  ],
};
```

### Separate Integration Tests

```javascript
// jest.integration.config.js
module.exports = {
  ...require('./jest.config'),
  testMatch: ['**/*.integration.test.ts'],
  testTimeout: 60000,
};
```

```bash
# Run integration tests
npm test -- --config=jest.integration.config.js
```

## Summary

**Key Concepts**:
- Use Testcontainers for real database testing
- Use `beforeAll` for container setup
- Test actual SQL queries and transactions
- Clean up data between tests
- Use realistic test scenarios
- Increase timeouts for container operations

## Next Steps

1. Review [Testing Patterns](./01-TESTING-PATTERNS.md)
2. Review [Mocking with Jest](./02-MOCKING.md)
3. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Integration tests with Testcontainers give you confidence that your code works with real infrastructure while keeping tests fast and isolated.
