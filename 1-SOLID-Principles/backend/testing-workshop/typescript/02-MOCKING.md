# TypeScript Mocking with Jest

## Overview

Jest provides built-in mocking capabilities that work seamlessly with TypeScript. This guide covers everything you need to know about mocking in TypeScript tests.

## Basic Mocking Concepts

### Creating Mocks

```typescript
// Create mock function
const mockFunction = jest.fn();

// Create mock object
const mockRepository: jest.Mocked<CustomerRepository> = {
  save: jest.fn(),
  findById: jest.fn(),
  findByEmail: jest.fn(),
  delete: jest.fn(),
};

// Partial mock
const partialMock: Partial<jest.Mocked<CustomerRepository>> = {
  findById: jest.fn(),
};
```

### Setup Return Values

```typescript
// Setup method to return specific value
mockRepository.findById.mockReturnValue(
  new Customer({ id: 1, name: 'John', email: 'john@example.com' })
);

// Setup async return
mockRepository.findById.mockResolvedValue(
  new Customer({ id: 1, name: 'John', email: 'john@example.com' })
);

// Multiple calls
mockRepository.findById
  .mockReturnValueOnce(customer1)
  .mockReturnValueOnce(customer2)
  .mockReturnValueOnce(customer3);
```

### Verify Method Calls

```typescript
// Verify method was called
expect(mockRepository.save).toHaveBeenCalled();

// Verify with specific arguments
expect(mockRepository.save).toHaveBeenCalledWith(customer);

// Verify call count
expect(mockRepository.save).toHaveBeenCalledTimes(1);

// Verify never called
expect(mockRepository.delete).not.toHaveBeenCalled();
```

## Setup Patterns

### Basic Setup

```typescript
describe('CustomerService', () => {
  it('should return customer when exists', async () => {
    // Arrange
    const mockRepository: jest.Mocked<CustomerRepository> = {
      findById: jest.fn().mockResolvedValue(
        new Customer({ id: 1, name: 'John Doe', email: 'john@example.com' })
      ),
    } as any;
    
    const service = new CustomerService(mockRepository);
    
    // Act
    const result = await service.getCustomer(1);
    
    // Assert
    expect(result).toBeDefined();
    expect(result?.name).toBe('John Doe');
  });
});
```

### Setup with mockImplementation

```typescript
it('should assign id when saving', async () => {
  // Arrange
  let savedCustomer: Customer | null = null;
  
  const mockRepository: jest.Mocked<CustomerRepository> = {
    save: jest.fn().mockImplementation((customer: Customer) => {
      savedCustomer = customer;
      return Promise.resolve();
    }),
  } as any;
  
  const service = new CustomerService(mockRepository);
  const customer = new Customer({ id: 0, name: 'John', email: 'john@example.com' });
  
  // Act
  await service.saveCustomer(customer);
  
  // Assert
  expect(savedCustomer).toBeDefined();
  expect(savedCustomer?.name).toBe('John');
});
```

### Setup Sequential Returns

```typescript
it('should retry on failure', async () => {
  // Arrange
  const mockRepository: jest.Mocked<CustomerRepository> = {
    findById: jest.fn()
      .mockResolvedValueOnce(null)  // First call returns null
      .mockResolvedValueOnce(null)  // Second call returns null
      .mockResolvedValueOnce(new Customer({ id: 1, name: 'John', email: 'john@example.com' })),
  } as any;
  
  const service = new CustomerService(mockRepository);
  
  // Act
  const result = await service.getCustomerWithRetry(1);
  
  // Assert
  expect(result).toBeDefined();
  expect(mockRepository.findById).toHaveBeenCalledTimes(3);
});
```

## Argument Matching

### Using expect.any

```typescript
// Match any value of type
expect(mockRepository.save).toHaveBeenCalledWith(expect.any(Customer));

// Match any number
expect(mockRepository.findById).toHaveBeenCalledWith(expect.any(Number));

// Match any string
expect(mockRepository.findByEmail).toHaveBeenCalledWith(expect.any(String));
```

### Using expect.objectContaining

```typescript
it('should save customer with correct properties', async () => {
  // Arrange
  const mockRepository: jest.Mocked<CustomerRepository> = {
    save: jest.fn(),
  } as any;
  
  const service = new CustomerService(mockRepository);
  const customer = new Customer({ id: 1, name: 'John', email: 'john@example.com' });
  
  // Act
  await service.saveCustomer(customer);
  
  // Assert
  expect(mockRepository.save).toHaveBeenCalledWith(
    expect.objectContaining({
      id: 1,
      name: 'John',
      email: 'john@example.com',
    })
  );
});
```

### Using expect.arrayContaining

```typescript
it('should save all customers', async () => {
  // Arrange
  const mockRepository: jest.Mocked<CustomerRepository> = {
    saveAll: jest.fn(),
  } as any;
  
  const service = new CustomerService(mockRepository);
  const customers = [customer1, customer2];
  
  // Act
  await service.saveAll(customers);
  
  // Assert
  expect(mockRepository.saveAll).toHaveBeenCalledWith(
    expect.arrayContaining([
      expect.objectContaining({ id: 1 }),
      expect.objectContaining({ id: 2 }),
    ])
  );
});
```

## Exception Handling

### Setup to Throw Exception

```typescript
it('should handle database exception', async () => {
  // Arrange
  const mockRepository: jest.Mocked<CustomerRepository> = {
    save: jest.fn().mockRejectedValue(new DatabaseException('Connection failed')),
  } as any;
  
  const service = new CustomerService(mockRepository);
  const customer = new Customer({ id: 1, name: 'John', email: 'john@example.com' });
  
  // Act & Assert
  await expect(service.saveCustomer(customer)).rejects.toThrow('Connection failed');
});
```

### Using mockRejectedValue

```typescript
it('should handle async errors', async () => {
  // Arrange
  const mockRepository: jest.Mocked<CustomerRepository> = {
    findById: jest.fn().mockRejectedValue(new Error('Database error')),
  } as any;
  
  const service = new CustomerService(mockRepository);
  
  // Act & Assert
  await expect(service.getCustomer(1)).rejects.toThrow('Database error');
});
```

## Spying

### Spy on Methods

```typescript
it('should call validation method', () => {
  // Arrange
  const service = new CustomerService(mockRepository);
  const spy = jest.spyOn(service as any, 'validateCustomer');
  
  // Act
  service.createCustomer(customer);
  
  // Assert
  expect(spy).toHaveBeenCalledWith(customer);
  
  // Cleanup
  spy.mockRestore();
});
```

### Spy on Object Methods

```typescript
it('should call repository method', async () => {
  // Arrange
  const repository = new CustomerRepository(mockConnection);
  const spy = jest.spyOn(repository, 'save');
  
  // Act
  await repository.save(customer);
  
  // Assert
  expect(spy).toHaveBeenCalledWith(customer);
});
```

## Module Mocking

### Mock Entire Module

```typescript
// Mock module
jest.mock('./CustomerRepository');

describe('CustomerService', () => {
  it('should use mocked repository', () => {
    const MockedRepository = CustomerRepository as jest.MockedClass<typeof CustomerRepository>;
    const mockInstance = new MockedRepository();
    
    mockInstance.findById.mockResolvedValue(customer);
    
    // Use mocked instance
  });
});
```

### Partial Module Mock

```typescript
jest.mock('./utils', () => ({
  ...jest.requireActual('./utils'),
  validateEmail: jest.fn().mockReturnValue(true),
}));
```

### Mock with Factory

```typescript
jest.mock('./CustomerRepository', () => {
  return {
    CustomerRepository: jest.fn().mockImplementation(() => {
      return {
        findById: jest.fn(),
        save: jest.fn(),
      };
    }),
  };
});
```

## Verification

### Verify Method Called

```typescript
it('should send email', async () => {
  // Arrange
  const mockEmailService: jest.Mocked<EmailService> = {
    sendOrderConfirmation: jest.fn(),
  } as any;
  
  const service = new OrderService(mockEmailService);
  const order = new Order({ id: 1, customerId: 100, total: new Money(50) });
  
  // Act
  await service.processOrder(order);
  
  // Assert
  expect(mockEmailService.sendOrderConfirmation).toHaveBeenCalledWith(
    expect.objectContaining({ id: 1 })
  );
});
```

### Verify Call Count

```typescript
// Verify called exactly once
expect(mock.method).toHaveBeenCalledTimes(1);

// Verify called at least once
expect(mock.method).toHaveBeenCalled();

// Verify never called
expect(mock.method).not.toHaveBeenCalled();
```

### Verify Call Order

```typescript
it('should call methods in order', async () => {
  // Arrange
  const mockRepository: jest.Mocked<CustomerRepository> = {
    save: jest.fn(),
  } as any;
  
  const mockEmail: jest.Mocked<EmailService> = {
    sendWelcomeEmail: jest.fn(),
  } as any;
  
  const service = new CustomerService(mockRepository, mockEmail);
  
  // Act
  await service.createCustomer(customer);
  
  // Assert
  const saveCalls = mockRepository.save.mock.calls;
  const emailCalls = mockEmail.sendWelcomeEmail.mock.calls;
  
  expect(saveCalls[0]).toBeDefined();
  expect(emailCalls[0]).toBeDefined();
});
```

## Advanced Patterns

### Type-Safe Mocks

```typescript
function createMock<T>(): jest.Mocked<T> {
  return {} as jest.Mocked<T>;
}

// Usage
const mockRepository = createMock<CustomerRepository>();
mockRepository.findById = jest.fn();
```

### Mock Factories

```typescript
function createMockCustomerRepository(): jest.Mocked<CustomerRepository> {
  return {
    save: jest.fn(),
    findById: jest.fn(),
    findByEmail: jest.fn(),
    delete: jest.fn(),
  } as jest.Mocked<CustomerRepository>;
}

// Usage
const mockRepository = createMockCustomerRepository();
```

### Clearing Mocks

```typescript
describe('CustomerService', () => {
  let mockRepository: jest.Mocked<CustomerRepository>;
  
  beforeEach(() => {
    mockRepository = createMockCustomerRepository();
  });
  
  afterEach(() => {
    jest.clearAllMocks();  // Clear call history
  });
  
  it('test 1', () => {
    // Test
  });
  
  it('test 2', () => {
    // Starts with clean mock
  });
});
```

## Testing with Multiple Mocks

```typescript
describe('OrderService', () => {
  let mockProductRepo: jest.Mocked<ProductRepository>;
  let mockInventory: jest.Mocked<InventoryService>;
  let mockPayment: jest.Mocked<PaymentService>;
  let mockEmail: jest.Mocked<EmailService>;
  let service: OrderService;
  
  beforeEach(() => {
    mockProductRepo = {
      findById: jest.fn(),
    } as any;
    
    mockInventory = {
      checkAvailability: jest.fn(),
    } as any;
    
    mockPayment = {
      processPayment: jest.fn(),
    } as any;
    
    mockEmail = {
      sendOrderConfirmation: jest.fn(),
    } as any;
    
    service = new OrderService(
      mockProductRepo,
      mockInventory,
      mockPayment,
      mockEmail
    );
  });
  
  it('should coordinate all services', async () => {
    // Arrange
    const product = new Product({ id: 1, name: 'Product', price: new Money(10) });
    mockProductRepo.findById.mockResolvedValue(product);
    mockInventory.checkAvailability.mockResolvedValue(true);
    mockPayment.processPayment.mockResolvedValue({ success: true, transactionId: 'txn_123' });
    
    const order = new Order({ id: 1, items: [{ productId: 1, quantity: 2 }] });
    
    // Act
    const result = await service.processOrder(order);
    
    // Assert
    expect(result.success).toBe(true);
    expect(mockInventory.checkAvailability).toHaveBeenCalledWith(1, 2);
    expect(mockPayment.processPayment).toHaveBeenCalled();
    expect(mockEmail.sendOrderConfirmation).toHaveBeenCalled();
  });
});
```

## Best Practices

### ✅ Do's

```typescript
// Use type-safe mocks
const mock: jest.Mocked<CustomerRepository> = { ... };

// Verify important interactions
expect(mock.criticalMethod).toHaveBeenCalled();

// Use descriptive variable names
const mockCustomerRepository = createMock<CustomerRepository>();

// Setup only what you need
mockRepository.findById.mockResolvedValue(customer);
```

### ❌ Don'ts

```typescript
// Don't use any without type safety
const mock: any = { ... };  // Bad

// Don't over-verify
expect(mock.logDebug).toHaveBeenCalledTimes(5);  // Too brittle

// Don't mock value objects
const mockMoney = jest.fn();  // Bad - use real Money

// Don't forget to clear mocks
// Always use afterEach(() => jest.clearAllMocks())
```

## Summary

**Key Jest Mocking Concepts**:
- Setup return values with `.mockReturnValue()` and `.mockResolvedValue()`
- Match parameters with `expect.any()`, `expect.objectContaining()`
- Verify calls with `expect().toHaveBeenCalled()`
- Use type-safe mocks with `jest.Mocked<T>`
- Clear mocks between tests
- Mock interfaces, not concrete classes

## Next Steps

1. Review [Testing Patterns](./01-TESTING-PATTERNS.md)
2. Learn [Integration Testing](./03-INTEGRATION-TESTING.md)
3. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Jest's built-in mocking works seamlessly with TypeScript. Use type-safe mocks to catch errors at compile time.
