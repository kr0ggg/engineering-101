# Testing Anti-Patterns - TypeScript Example (Jest)

**Section**: [Testing Anti-Patterns to Avoid](../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid)

**Navigation**: [← Previous: Customer Service Tests](./10-customer-service-tests.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Testing Best Practices →](./12-testing-best-practices.md)

---

```typescript
// TypeScript Example - Testing Anti-Patterns to Avoid (Jest)
// File: 2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns.ts

import { Customer, CustomerId, CustomerStatus } from './06-customer-module';
import { Money } from './02-money-value-object';

// ❌ ANTI-PATTERN 1: Testing Infrastructure Concerns
describe('❌ BAD: Testing Infrastructure Concerns', () => {
    it('should connect to database', async () => {
        // ❌ Don't test database connections in domain tests
        const connection = await connectToDatabase();
        expect(connection.isConnected).toBe(true);
    });

    it('should log messages correctly', () => {
        // ❌ Don't test logging framework functionality
        const logger = new Logger();
        logger.info('test message');
        expect(logger.getLastMessage()).toBe('test message');
    });

    it('should serialize to JSON', () => {
        // ❌ Don't test framework serialization
        const customer = new Customer(/* ... */);
        const json = JSON.stringify(customer);
        expect(json).toContain('"id"');
    });
});

// ❌ ANTI-PATTERN 2: Testing Implementation Details
describe('❌ BAD: Testing Implementation Details', () => {
    it('should have correct private field values', () => {
        // ❌ Don't test private fields directly
        const customer = new Customer(
            new CustomerId('customer-1'),
            'John Doe',
            EmailAddress.fromString('john@example.com')
        );
        
        // ❌ Accessing private fields through any casting
        expect((customer as any)._status).toBe(CustomerStatus.Pending);
        expect((customer as any)._createdAt).toBeDefined();
    });

    it('should call internal methods in correct order', () => {
        // ❌ Don't test internal method calls
        const customer = new Customer(/* ... */);
        const spy = jest.spyOn(customer as any, '_validateStatus');
        
        customer.activate();
        
        // ❌ Testing implementation details
        expect(spy).toHaveBeenCalledTimes(1);
        expect(spy).toHaveBeenCalledWith(CustomerStatus.Active);
    });

    it('should use correct data structure internally', () => {
        // ❌ Don't test internal data structures
        const order = new Order(/* ... */);
        
        // ❌ Testing internal array structure
        expect((order as any)._items).toBeInstanceOf(Array);
        expect((order as any)._items.length).toBe(0);
    });
});

// ❌ ANTI-PATTERN 3: Over-Mocking
describe('❌ BAD: Over-Mocking', () => {
    it('should calculate order total with excessive mocking', () => {
        // ❌ Mocking everything, even simple objects
        const mockOrder = {
            totalAmount: jest.fn().mockReturnValue(Money.fromAmount(100, 'USD')),
            itemCount: jest.fn().mockReturnValue(2),
            customerId: jest.fn().mockReturnValue(new CustomerId('customer-1'))
        };
        
        const mockCustomer = {
            type: jest.fn().mockReturnValue('Premium'),
            isActive: jest.fn().mockReturnValue(true)
        };
        
        const mockAddress = {
            state: jest.fn().mockReturnValue('CA'),
            country: jest.fn().mockReturnValue('US')
        };
        
        const mockPricingService = {
            calculateOrderTotal: jest.fn().mockReturnValue(Money.fromAmount(95, 'USD'))
        };
        
        // ❌ Too many mocks make tests brittle and hard to understand
        const result = mockPricingService.calculateOrderTotal(mockOrder, mockCustomer, mockAddress);
        expect(result.amount).toBe(95);
    });
});

// ❌ ANTI-PATTERN 4: Testing Technical Framework Code
describe('❌ BAD: Testing Technical Framework Code', () => {
    it('should validate email format using regex', () => {
        // ❌ Don't test framework/library functionality
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        expect(emailRegex.test('test@example.com')).toBe(true);
        expect(emailRegex.test('invalid-email')).toBe(false);
    });

    it('should format dates correctly', () => {
        // ❌ Don't test built-in JavaScript functionality
        const date = new Date('2023-01-01');
        expect(date.toISOString()).toBe('2023-01-01T00:00:00.000Z');
    });

    it('should perform array operations', () => {
        // ❌ Don't test JavaScript array methods
        const numbers = [1, 2, 3, 4, 5];
        const doubled = numbers.map(n => n * 2);
        expect(doubled).toEqual([2, 4, 6, 8, 10]);
    });
});

// ❌ ANTI-PATTERN 5: Testing Multiple Concerns in One Test
describe('❌ BAD: Testing Multiple Concerns', () => {
    it('should handle complete customer workflow', () => {
        // ❌ Testing too many things in one test
        const customer = new Customer(/* ... */);
        
        // Testing creation
        expect(customer.id).toBeDefined();
        expect(customer.name).toBe('John Doe');
        
        // Testing activation
        customer.activate();
        expect(customer.status).toBe(CustomerStatus.Active);
        
        // Testing email update
        const newEmail = EmailAddress.fromString('new@example.com');
        const updatedCustomer = customer.updateEmail(newEmail);
        expect(updatedCustomer.email.equals(newEmail)).toBe(true);
        
        // Testing deactivation
        updatedCustomer.deactivate();
        expect(updatedCustomer.status).toBe(CustomerStatus.Inactive);
        
        // ❌ This test is doing too much and will be hard to debug when it fails
    });
});

// ❌ ANTI-PATTERN 6: Testing with Real External Dependencies
describe('❌ BAD: Testing with Real External Dependencies', () => {
    it('should send email to customer', async () => {
        // ❌ Don't test with real email service
        const emailService = new RealEmailService();
        const customer = new Customer(/* ... */);
        
        await emailService.sendWelcomeEmail(customer);
        
        // ❌ This test will fail if email service is down
        // ❌ This test will send real emails
        // ❌ This test will be slow
    });

    it('should save to database', async () => {
        // ❌ Don't test with real database
        const repository = new DatabaseCustomerRepository();
        const customer = new Customer(/* ... */);
        
        await repository.save(customer);
        const saved = await repository.findById(customer.id);
        
        // ❌ This test requires database setup
        // ❌ This test will be slow
        // ❌ This test might fail due to database issues
    });
});

// ❌ ANTI-PATTERN 7: Testing with Non-Deterministic Data
describe('❌ BAD: Testing with Non-Deterministic Data', () => {
    it('should create customer with generated ID', () => {
        // ❌ Don't test with random/generated data
        const customer1 = Customer.create('John Doe', EmailAddress.fromString('john@example.com'));
        const customer2 = Customer.create('Jane Doe', EmailAddress.fromString('jane@example.com'));
        
        // ❌ These IDs are random and unpredictable
        expect(customer1.id.toString()).toMatch(/^customer_/);
        expect(customer2.id.toString()).toMatch(/^customer_/);
        expect(customer1.id.equals(customer2.id)).toBe(false);
    });

    it('should handle current date', () => {
        // ❌ Don't test with current date/time
        const customer = new Customer(/* ... */);
        
        // ❌ This test will fail at different times
        expect(customer.createdAt.getTime()).toBeLessThanOrEqual(Date.now());
    });
});

// ❌ ANTI-PATTERN 8: Testing with Complex Setup
describe('❌ BAD: Testing with Complex Setup', () => {
    it('should process complex order scenario', () => {
        // ❌ Don't create overly complex test scenarios
        const customer = new Customer(/* ... */);
        const order = new Order(/* ... */);
        
        // Add 20 different products with various quantities
        for (let i = 0; i < 20; i++) {
            order.addItem(
                new ProductId(`product-${i}`),
                Math.floor(Math.random() * 10) + 1,
                Money.fromAmount(Math.random() * 100, 'USD')
            );
        }
        
        // Apply various discounts
        const pricingService = new PricingService();
        const total = pricingService.calculateOrderTotal(order, customer, address);
        
        // ❌ This test is too complex and hard to understand
        expect(total.amount).toBeGreaterThan(0);
    });
});

// ✅ GOOD: Proper Domain Testing Examples
describe('✅ GOOD: Proper Domain Testing', () => {
    it('should activate customer when valid', () => {
        // ✅ Test business behavior, not implementation
        const customer = new Customer(
            new CustomerId('customer-1'),
            'John Doe',
            EmailAddress.fromString('john@example.com')
        );
        
        customer.activate();
        
        expect(customer.status).toBe(CustomerStatus.Active);
        expect(customer.isActive()).toBe(true);
    });

    it('should prevent activation of suspended customer', () => {
        // ✅ Test business rules and constraints
        const customer = new Customer(/* ... */);
        customer.suspend();
        
        expect(() => {
            customer.activate();
        }).toThrow('Cannot activate suspended customer');
    });

    it('should calculate correct order total', () => {
        // ✅ Test business calculations
        const order = new Order(/* ... */);
        order.addItem(
            new ProductId('product-1'),
            2,
            Money.fromAmount(25, 'USD')
        );
        
        expect(order.totalAmount.equals(Money.fromAmount(50, 'USD'))).toBe(true);
    });
});
```

## Key Concepts Demonstrated

### Testing Anti-Patterns to Avoid

#### 1. **Testing Infrastructure Concerns**
- ❌ Don't test database connections, logging, or serialization
- ✅ Focus on business logic instead

#### 2. **Testing Implementation Details**
- ❌ Don't test private fields, internal methods, or data structures
- ✅ Test the public interface and behavior

#### 3. **Over-Mocking**
- ❌ Avoid mocking too many dependencies
- ✅ Mock only what's necessary for the test

#### 4. **Testing Technical Framework Code**
- ❌ Don't test framework methods or third-party library functionality
- ✅ Test your domain logic

#### 5. **Testing Multiple Concerns**
- ❌ Don't test too many things in one test
- ✅ Each test should focus on one concept

#### 6. **Testing with Real External Dependencies**
- ❌ Don't test with real databases, email services, or external APIs
- ✅ Use mocks and test doubles

#### 7. **Testing with Non-Deterministic Data**
- ❌ Don't test with random data or current timestamps
- ✅ Use predictable test data

#### 8. **Testing with Complex Setup**
- ❌ Don't create overly complex test scenarios
- ✅ Keep tests simple and focused

### Jest Testing Anti-Patterns
- **Excessive Mocking**: Using `jest.fn()` for everything
- **Implementation Testing**: Testing private methods and fields
- **Framework Testing**: Testing JavaScript built-ins
- **Integration in Unit Tests**: Testing with real external services

## Related Concepts

- [Order Tests](./07-order-tests.md) - Examples of good testing practices
- [Money Tests](./08-money-tests.md) - Value object testing examples
- [Customer Service Tests](./10-customer-service-tests.md) - Mocking best practices
- [Testing Best Practices](./12-testing-best-practices.md) - What to do instead
- [Testing Anti-Patterns](../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid) - Anti-pattern concepts

/*
 * Navigation:
 * Previous: 10-customer-service-tests.md
 * Next: 12-testing-best-practices.md
 *
 * Back to: [Testing Anti-Patterns to Avoid](../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid)
 */
