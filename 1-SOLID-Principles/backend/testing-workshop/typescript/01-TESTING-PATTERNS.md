# TypeScript Testing Patterns for SOLID Principles

## Overview

This guide covers common testing patterns for TypeScript backend development, specifically focused on testing code that follows SOLID principles using Jest.

## Testing Stack

- **Jest** - Test framework and mocking
- **ts-jest** - TypeScript support

## Basic Test Structure

### Arrange-Act-Assert (AAA) Pattern

```typescript
describe('ClassName', () => {
  it('should do something when condition', () => {
    // Arrange - Set up test data and dependencies
    const dependency = jest.fn();
    const sut = new SystemUnderTest(dependency);
    
    // Act - Execute the method being tested
    const result = sut.methodToTest();
    
    // Assert - Verify the expected outcome
    expect(result).toBe(expectedValue);
  });
});
```

### Using test.each for Parameterized Tests

```typescript
describe('PriceCalculator', () => {
  test.each([
    [10, 2, 20],
    [15, 3, 45],
    [0, 5, 0],
  ])('calculateTotal(%i, %i) should return %i', (price, quantity, expected) => {
    // Arrange
    const calculator = new PriceCalculator();
    
    // Act
    const result = calculator.calculateTotal(price, quantity);
    
    // Assert
    expect(result).toBe(expected);
  });
});
```

## Testing SOLID Principles

### 1. Single Responsibility Principle (SRP)

Test each responsibility independently.

#### After SRP - Focused Classes

```typescript
// Easy to test - single responsibility
class CustomerValidator {
  validate(customer: Customer): ValidationResult {
    if (!customer.email) {
      return ValidationResult.failure('Email is required');
    }
    
    if (!this.isValidEmail(customer.email)) {
      return ValidationResult.failure('Invalid email format');
    }
    
    return ValidationResult.success();
  }
}

// Focused test
describe('CustomerValidator', () => {
  it('should fail when email is empty', () => {
    // Arrange
    const validator = new CustomerValidator();
    const customer = new Customer({ id: 1, name: 'John', email: '' });
    
    // Act
    const result = validator.validate(customer);
    
    // Assert
    expect(result.isValid).toBe(false);
    expect(result.errors).toContain('Email is required');
  });

  test.each(['invalid', '@example.com', 'user@'])(
    'should fail when email is invalid: %s',
    (invalidEmail) => {
      // Arrange
      const validator = new CustomerValidator();
      const customer = new Customer({ id: 1, name: 'John', email: invalidEmail });
      
      // Act
      const result = validator.validate(customer);
      
      // Assert
      expect(result.isValid).toBe(false);
      expect(result.errors).toContain('Invalid email format');
    }
  );
});
```

### 2. Open/Closed Principle (OCP)

Test base behavior and extensions independently.

#### Strategy Pattern Testing

```typescript
// Interface
interface DiscountStrategy {
  applyDiscount(originalPrice: Money): Money;
}

// Implementation
class PercentageDiscount implements DiscountStrategy {
  constructor(private percentage: number) {}
  
  applyDiscount(originalPrice: Money): Money {
    const discount = originalPrice.amount * (this.percentage / 100);
    return new Money(originalPrice.amount - discount);
  }
}

// Test base contract
abstract class DiscountStrategyContractTest {
  protected abstract createStrategy(): DiscountStrategy;
  
  test('should not return negative price', () => {
    // Arrange
    const strategy = this.createStrategy();
    const price = new Money(10);
    
    // Act
    const result = strategy.applyDiscount(price);
    
    // Assert
    expect(result.amount).toBeGreaterThanOrEqual(0);
  });
}

// Test specific implementation
describe('PercentageDiscount', () => {
  test.each([
    [100, 10, 90],
    [50, 20, 40],
    [75, 15, 63.75],
  ])('should calculate correct percentage: %i with %i%', (original, percentage, expected) => {
    // Arrange
    const strategy = new PercentageDiscount(percentage);
    const price = new Money(original);
    
    // Act
    const result = strategy.applyDiscount(price);
    
    // Assert
    expect(result.amount).toBe(expected);
  });
});
```

### 3. Liskov Substitution Principle (LSP)

Test that derived classes can substitute base classes.

#### Repository Pattern Testing

```typescript
// Base repository contract tests
abstract class RepositoryContractTest<T, ID> {
  protected abstract createRepository(): Repository<T, ID>;
  protected abstract createEntity(id: ID): T;
  protected abstract getEntityId(entity: T): ID;
  
  test('save should persist entity', async () => {
    // Arrange
    const repository = this.createRepository();
    const entity = this.createEntity(1 as ID);
    
    // Act
    await repository.save(entity);
    
    // Assert
    const retrieved = await repository.findById(this.getEntityId(entity));
    expect(retrieved).toBeDefined();
  });
  
  test('findById should return null when not exists', async () => {
    // Arrange
    const repository = this.createRepository();
    
    // Act
    const result = await repository.findById(999 as ID);
    
    // Assert
    expect(result).toBeNull();
  });
}

// Concrete implementation tests
describe('CustomerRepository', () => {
  let mockConnection: jest.Mocked<Connection>;
  
  beforeEach(() => {
    mockConnection = {
      query: jest.fn(),
      execute: jest.fn(),
    } as any;
  });
  
  it('should save customer', async () => {
    const repository = new CustomerRepository(mockConnection);
    const customer = new Customer({ id: 1, name: 'John', email: 'john@example.com' });
    
    await repository.save(customer);
    
    expect(mockConnection.execute).toHaveBeenCalled();
  });
});
```

### 4. Interface Segregation Principle (ISP)

Test focused interfaces independently.

#### After ISP - Focused Interfaces

```typescript
// Focused interfaces
interface CustomerReader {
  findById(id: number): Promise<Customer | null>;
  findByEmail(email: string): Promise<Customer | null>;
}

interface CustomerWriter {
  save(customer: Customer): Promise<void>;
  delete(id: number): Promise<void>;
}

// Test only what you need
describe('CustomerDisplayService', () => {
  it('should use reader', async () => {
    // Arrange - Only mock what's needed
    const mockReader: jest.Mocked<CustomerReader> = {
      findById: jest.fn().mockResolvedValue(
        new Customer({ id: 1, name: 'John', email: 'john@example.com' })
      ),
      findByEmail: jest.fn(),
    };
    
    const service = new CustomerDisplayService(mockReader);
    
    // Act
    const result = await service.getCustomer(1);
    
    // Assert
    expect(result).toBeDefined();
  });
});

describe('CustomerManagementService', () => {
  it('should use writer', async () => {
    // Arrange - Only mock what's needed
    const mockWriter: jest.Mocked<CustomerWriter> = {
      save: jest.fn(),
      delete: jest.fn(),
    };
    
    const service = new CustomerManagementService(mockWriter);
    const customer = new Customer({ id: 1, name: 'John', email: 'john@example.com' });
    
    // Act
    await service.createCustomer(customer);
    
    // Assert
    expect(mockWriter.save).toHaveBeenCalledWith(customer);
  });
});
```

### 5. Dependency Inversion Principle (DIP)

Test against abstractions using dependency injection.

#### Testing with Injected Dependencies

```typescript
// Service depends on abstraction
class OrderService {
  constructor(
    private productRepository: ProductRepository,
    private priceCalculator: PriceCalculator,
    private emailService: EmailService
  ) {}
  
  async createOrder(customerId: number, items: OrderItem[]): Promise<Order> {
    // Load products
    const productIds = items.map(item => item.productId);
    const products = await this.productRepository.findByIds(productIds);
    
    // Calculate total
    const total = this.priceCalculator.calculateTotal(items, products);
    
    // Create order
    const order = new Order({ customerId, items, total });
    
    // Send confirmation
    await this.emailService.sendOrderConfirmation(order);
    
    return order;
  }
}

// Easy to test with mocks
describe('OrderService', () => {
  it('should calculate total and send email', async () => {
    // Arrange
    const mockProductRepo: jest.Mocked<ProductRepository> = {
      findByIds: jest.fn().mockResolvedValue([
        new Product({ id: 1, name: 'Product 1', price: new Money(10) }),
        new Product({ id: 2, name: 'Product 2', price: new Money(20) }),
      ]),
    } as any;
    
    const mockCalculator: jest.Mocked<PriceCalculator> = {
      calculateTotal: jest.fn().mockReturnValue(new Money(40)),
    } as any;
    
    const mockEmailService: jest.Mocked<EmailService> = {
      sendOrderConfirmation: jest.fn(),
    } as any;
    
    const service = new OrderService(
      mockProductRepo,
      mockCalculator,
      mockEmailService
    );
    
    const items = [
      new OrderItem({ productId: 1, quantity: 2 }),
      new OrderItem({ productId: 2, quantity: 1 }),
    ];
    
    // Act
    const order = await service.createOrder(1, items);
    
    // Assert
    expect(order.total.amount).toBe(40);
    expect(mockEmailService.sendOrderConfirmation).toHaveBeenCalledWith(
      expect.objectContaining({ total: expect.objectContaining({ amount: 40 }) })
    );
  });
});
```

## Advanced Testing Patterns

### Nested Describes

```typescript
describe('OrderService', () => {
  describe('createOrder', () => {
    it('should calculate total correctly', async () => {
      // Test implementation
    });
    
    it('should send confirmation email', async () => {
      // Test implementation
    });
  });
  
  describe('cancelOrder', () => {
    it('should refund payment', async () => {
      // Test implementation
    });
  });
});
```

### Setup with beforeEach

```typescript
describe('CustomerService', () => {
  let mockRepository: jest.Mocked<CustomerRepository>;
  let mockEmailService: jest.Mocked<EmailService>;
  let service: CustomerService;
  
  beforeEach(() => {
    mockRepository = {
      save: jest.fn(),
      findById: jest.fn(),
    } as any;
    
    mockEmailService = {
      sendWelcomeEmail: jest.fn(),
    } as any;
    
    service = new CustomerService(mockRepository, mockEmailService);
  });
  
  it('should save and send email', async () => {
    const customer = new Customer({ id: 1, name: 'John', email: 'john@example.com' });
    
    await service.createCustomer(customer);
    
    expect(mockRepository.save).toHaveBeenCalledWith(customer);
    expect(mockEmailService.sendWelcomeEmail).toHaveBeenCalledWith(customer);
  });
});
```

### Custom Matchers

```typescript
expect.extend({
  toBeValidCustomer(received: Customer) {
    const pass = 
      received !== null &&
      received.id !== undefined &&
      received.name !== '' &&
      received.email?.includes('@');
    
    return {
      pass,
      message: () => `expected ${received} to be a valid customer`,
    };
  },
});

// Usage
it('should return valid customer', () => {
  const customer = service.createCustomer('John', 'john@example.com');
  expect(customer).toBeValidCustomer();
});
```

### Test Data Builders

```typescript
class OrderBuilder {
  private id = 1;
  private customerId = 1;
  private items: OrderItem[] = [];
  private total = new Money(0);
  
  withId(id: number): this {
    this.id = id;
    return this;
  }
  
  forCustomer(customerId: number): this {
    this.customerId = customerId;
    return this;
  }
  
  withItem(productId: number, quantity: number): this {
    this.items.push(new OrderItem({ productId, quantity }));
    return this;
  }
  
  withTotal(total: Money): this {
    this.total = total;
    return this;
  }
  
  build(): Order {
    return new Order({
      id: this.id,
      customerId: this.customerId,
      items: this.items,
      total: this.total,
    });
  }
}

// Usage
it('should process order with multiple items', async () => {
  const order = new OrderBuilder()
    .forCustomer(1)
    .withItem(1, 2)
    .withItem(2, 1)
    .withTotal(new Money(40))
    .build();
  
  const result = await service.processOrder(order);
  expect(result).toBe(true);
});
```

## Summary

**Key Testing Patterns**:
- Use AAA pattern consistently
- Test each SOLID principle appropriately
- Use `test.each` for parameterized tests
- Create contract tests for LSP
- Use focused interfaces for ISP
- Inject dependencies for DIP
- Use test builders for complex objects
- Leverage TypeScript types for type-safe mocks

## Next Steps

1. Review [Mocking with Jest](./02-MOCKING.md)
2. Learn [Integration Testing](./03-INTEGRATION-TESTING.md)
3. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Good testing patterns make your tests maintainable and your code more testable. Follow SOLID principles in both production and test code.
