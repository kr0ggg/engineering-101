# Testing Best Practices - TypeScript Example (Jest)

**Section**: [Best Practices for DDD Unit Testing](../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing)

**Navigation**: [← Previous: Testing Anti-Patterns](./11-testing-anti-patterns.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Domain Modeling Best Practices →](./13-domain-modeling-best-practices.md)

---

```typescript
// TypeScript Example - Testing Best Practices (Jest)
// File: 2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices.ts

import { Customer, CustomerId, CustomerStatus } from './06-customer-module';
import { Money } from './02-money-value-object';
import { Order, OrderId, ProductId } from './03-order-entity';

// ✅ BEST PRACTICE 1: Test Behavior, Not Implementation
describe('✅ GOOD: Test Behavior, Not Implementation', () => {
    it('should activate customer and make them active', () => {
        // ✅ Test what the object does, not how it does it
        const customer = createTestCustomer();
        
        customer.activate();
        
        expect(customer.status).toBe(CustomerStatus.Active);
        expect(customer.isActive()).toBe(true);
        expect(customer.canPlaceOrders()).toBe(true);
    });

    it('should prevent order modification after confirmation', () => {
        // ✅ Test business behavior and constraints
        const order = createTestOrder();
        order.addItem(createTestProductId(), 2, Money.fromAmount(25, 'USD'));
        order.confirm();
        
        expect(() => {
            order.addItem(createTestProductId(), 1, Money.fromAmount(10, 'USD'));
        }).toThrow('Cannot modify confirmed order');
        
        expect(order.canBeModified()).toBe(false);
    });
});

// ✅ BEST PRACTICE 2: Use Descriptive Test Names
describe('✅ GOOD: Descriptive Test Names', () => {
    it('should throw error when trying to activate suspended customer', () => {
        // ✅ Clear scenario: what we're testing
        const customer = createTestCustomer();
        customer.suspend();
        
        expect(() => {
            customer.activate();
        }).toThrow('Cannot activate suspended customer');
    });

    it('should apply 15% discount for VIP customers on orders over $100', () => {
        // ✅ Clear business rule being tested
        const vipCustomer = createVipCustomer();
        const largeOrder = createLargeOrder(150); // $150 order
        
        const total = pricingService.calculateOrderTotal(largeOrder, vipCustomer, createTestAddress());
        
        // VIP gets 15% discount: $150 * 0.85 = $127.50
        expect(total.amount).toBeCloseTo(127.50, 2);
    });

    it('should allow customer to update their own email address', () => {
        // ✅ Clear scenario and expected outcome
        const customer = createTestCustomer();
        const newEmail = EmailAddress.fromString('newemail@example.com');
        
        const updatedCustomer = customer.updateEmail(newEmail);
        
        expect(updatedCustomer.email.equals(newEmail)).toBe(true);
    });
});

// ✅ BEST PRACTICE 3: Test Edge Cases and Business Rules
describe('✅ GOOD: Test Edge Cases and Business Rules', () => {
    describe('Order Item Validation', () => {
        it('should throw error for zero quantity', () => {
            expect(() => {
                new OrderItem(
                    createTestProductId(),
                    0, // Invalid quantity
                    Money.fromAmount(25, 'USD')
                );
            }).toThrow('Quantity must be positive');
        });

        it('should throw error for negative quantity', () => {
            expect(() => {
                new OrderItem(
                    createTestProductId(),
                    -1, // Invalid quantity
                    Money.fromAmount(25, 'USD')
                );
            }).toThrow('Quantity must be positive');
        });

        it('should handle maximum allowed quantity', () => {
            // ✅ Test boundary conditions
            const maxQuantity = 999999;
            const item = new OrderItem(
                createTestProductId(),
                maxQuantity,
                Money.fromAmount(0.01, 'USD')
            );
            
            expect(item.quantity).toBe(maxQuantity);
        });
    });

    describe('Money Value Object Edge Cases', () => {
        it('should handle very small amounts', () => {
            const smallAmount = Money.fromAmount(0.01, 'USD');
            expect(smallAmount.amount).toBe(0.01);
        });

        it('should handle very large amounts', () => {
            const largeAmount = Money.fromAmount(999999999.99, 'USD');
            expect(largeAmount.amount).toBe(999999999.99);
        });

        it('should prevent currency mixing in arithmetic', () => {
            const usdAmount = Money.fromAmount(100, 'USD');
            const eurAmount = Money.fromAmount(100, 'EUR');
            
            expect(() => {
                usdAmount.add(eurAmount);
            }).toThrow('Cannot add different currencies');
        });
    });
});

// ✅ BEST PRACTICE 4: Keep Tests Simple and Focused
describe('✅ GOOD: Simple and Focused Tests', () => {
    it('should create customer with valid data', () => {
        // ✅ One concept per test
        const customer = new Customer(
            new CustomerId('customer-1'),
            'John Doe',
            EmailAddress.fromString('john@example.com')
        );
        
        expect(customer.name).toBe('John Doe');
        expect(customer.status).toBe(CustomerStatus.Pending);
    });

    it('should activate customer', () => {
        // ✅ One behavior per test
        const customer = createTestCustomer();
        
        customer.activate();
        
        expect(customer.status).toBe(CustomerStatus.Active);
    });

    it('should deactivate customer', () => {
        // ✅ One behavior per test
        const customer = createTestCustomer();
        customer.activate(); // First activate
        
        customer.deactivate();
        
        expect(customer.status).toBe(CustomerStatus.Inactive);
    });
});

// ✅ BEST PRACTICE 5: Use Domain Language in Tests
describe('✅ GOOD: Domain Language in Tests', () => {
    it('should allow active customer to place orders', () => {
        // ✅ Use business terminology
        const activeCustomer = createActiveCustomer();
        
        expect(activeCustomer.canPlaceOrders()).toBe(true);
    });

    it('should prevent suspended customer from placing orders', () => {
        // ✅ Use business terminology
        const suspendedCustomer = createSuspendedCustomer();
        
        expect(suspendedCustomer.canPlaceOrders()).toBe(false);
    });

    it('should calculate order total including tax and shipping', () => {
        // ✅ Use business terminology
        const order = createOrderWithItems();
        const customer = createStandardCustomer();
        const address = createCaliforniaAddress();
        
        const total = pricingService.calculateOrderTotal(order, customer, address);
        
        expect(total.amount).toBeGreaterThan(order.totalAmount.amount);
    });
});

// ✅ BEST PRACTICE 6: Arrange-Act-Assert Pattern
describe('✅ GOOD: Arrange-Act-Assert Pattern', () => {
    it('should apply bulk discount for large orders', () => {
        // ✅ Arrange - Set up test data
        const customer = createStandardCustomer();
        const order = createLargeOrder(25); // 25 items
        const address = createTestAddress();
        
        // ✅ Act - Execute the behavior
        const total = pricingService.calculateOrderTotal(order, customer, address);
        
        // ✅ Assert - Verify the outcome
        expect(total.amount).toBeLessThan(order.totalAmount.amount);
    });

    it('should prevent order confirmation without items', () => {
        // ✅ Arrange
        const emptyOrder = new Order(
            new OrderId('empty-order'),
            new CustomerId('customer-1')
        );
        
        // ✅ Act & Assert
        expect(() => {
            emptyOrder.confirm();
        }).toThrow('Cannot confirm empty order');
    });
});

// ✅ BEST PRACTICE 7: Test Error Conditions
describe('✅ GOOD: Test Error Conditions', () => {
    it('should throw descriptive error for invalid email', () => {
        expect(() => {
            EmailAddress.fromString('invalid-email');
        }).toThrow('Invalid email address format: invalid-email');
    });

    it('should throw error when customer not found', async () => {
        const nonExistentId = CustomerId.generate();
        
        await expect(
            customerService.getCustomerById(nonExistentId)
        ).rejects.toThrow('Customer not found');
    });

    it('should throw error for inactive customer pricing', () => {
        const inactiveCustomer = createInactiveCustomer();
        const order = createTestOrder();
        
        expect(() => {
            pricingService.calculateOrderTotal(order, inactiveCustomer, createTestAddress());
        }).toThrow('Cannot calculate pricing for inactive customer');
    });
});

// ✅ BEST PRACTICE 8: Use Helper Methods for Test Data
describe('✅ GOOD: Helper Methods for Test Data', () => {
    // ✅ Helper methods make tests readable and maintainable
    function createTestCustomer(): Customer {
        return new Customer(
            new CustomerId('test-customer'),
            'Test Customer',
            EmailAddress.fromString('test@example.com')
        );
    }

    function createActiveCustomer(): Customer {
        const customer = createTestCustomer();
        customer.activate();
        return customer;
    }

    function createSuspendedCustomer(): Customer {
        const customer = createTestCustomer();
        customer.suspend();
        return customer;
    }

    function createTestOrder(): Order {
        const order = new Order(
            new OrderId('test-order'),
            new CustomerId('test-customer')
        );
        order.addItem(
            createTestProductId(),
            2,
            Money.fromAmount(25, 'USD')
        );
        return order;
    }

    function createTestProductId(): ProductId {
        return new ProductId('test-product');
    }

    function createStandardCustomer(): Customer {
        return {
            id: 'customer-1',
            type: 'Standard',
            isActive: true
        };
    }

    function createVipCustomer(): Customer {
        return {
            id: 'customer-vip',
            type: 'VIP',
            isActive: true
        };
    }

    function createInactiveCustomer(): Customer {
        return {
            id: 'customer-inactive',
            type: 'Standard',
            isActive: false
        };
    }

    function createTestAddress(): Address {
        return { state: 'CA', country: 'US' };
    }

    function createCaliforniaAddress(): Address {
        return { state: 'CA', country: 'US' };
    }

    function createLargeOrder(baseAmount: number): Order {
        const order = new Order(
            new OrderId('large-order'),
            new CustomerId('customer-1')
        );
        
        // Add multiple items to reach the base amount
        const itemCount = Math.ceil(baseAmount / 10);
        for (let i = 0; i < itemCount; i++) {
            order.addItem(
                new ProductId(`product-${i}`),
                1,
                Money.fromAmount(10, 'USD')
            );
        }
        
        return order;
    }

    function createOrderWithItems(): Order {
        const order = new Order(
            new OrderId('order-with-items'),
            new CustomerId('customer-1')
        );
        
        order.addItem(
            new ProductId('product-1'),
            2,
            Money.fromAmount(25, 'USD')
        );
        
        order.addItem(
            new ProductId('product-2'),
            1,
            Money.fromAmount(15, 'USD')
        );
        
        return order;
    }
});

// ✅ BEST PRACTICE 9: Test Business Rules Explicitly
describe('✅ GOOD: Test Business Rules Explicitly', () => {
    it('should enforce customer status business rules', () => {
        const customer = createTestCustomer();
        
        // Business rule: Only active customers can place orders
        expect(customer.canPlaceOrders()).toBe(false);
        
        customer.activate();
        expect(customer.canPlaceOrders()).toBe(true);
        
        customer.suspend();
        expect(customer.canPlaceOrders()).toBe(false);
    });

    it('should enforce order modification business rules', () => {
        const order = createTestOrder();
        
        // Business rule: Only draft orders can be modified
        expect(order.canBeModified()).toBe(true);
        
        order.confirm();
        expect(order.canBeModified()).toBe(false);
    });

    it('should enforce order confirmation business rules', () => {
        const emptyOrder = new Order(
            new OrderId('empty'),
            new CustomerId('customer-1')
        );
        
        // Business rule: Orders must have items before confirmation
        expect(emptyOrder.canBeConfirmed()).toBe(false);
        
        emptyOrder.addItem(createTestProductId(), 1, Money.fromAmount(10, 'USD'));
        expect(emptyOrder.canBeConfirmed()).toBe(true);
    });
});

// ✅ BEST PRACTICE 10: Use Meaningful Assertions
describe('✅ GOOD: Meaningful Assertions', () => {
    it('should calculate correct order total', () => {
        const order = createTestOrder();
        
        // ✅ Specific assertion about business calculation
        expect(order.totalAmount.equals(Money.fromAmount(50, 'USD'))).toBe(true);
    });

    it('should maintain customer identity after updates', () => {
        const customer = createTestCustomer();
        const originalId = customer.id;
        
        const updatedCustomer = customer.updateEmail(
            EmailAddress.fromString('newemail@example.com')
        );
        
        // ✅ Specific assertion about identity preservation
        expect(updatedCustomer.id.equals(originalId)).toBe(true);
    });

    it('should preserve order item equality', () => {
        const productId = createTestProductId();
        const unitPrice = Money.fromAmount(25, 'USD');
        
        const item1 = new OrderItem(productId, 2, unitPrice);
        const item2 = new OrderItem(productId, 2, unitPrice);
        
        // ✅ Specific assertion about value equality
        expect(item1.equals(item2)).toBe(true);
    });
});
```

## Key Concepts Demonstrated

### Testing Best Practices

#### 1. **Test Behavior, Not Implementation**
- ✅ Focus on what the domain object does, not how it does it
- ✅ Test the observable behavior and outcomes
- ✅ Avoid testing private fields or internal methods

#### 2. **Use Descriptive Test Names**
- ✅ Test names should clearly express the scenario, action, and expected outcome
- ✅ Make them readable to business stakeholders
- ✅ Use domain language in test names

#### 3. **Test Edge Cases and Business Rules**
- ✅ Ensure comprehensive coverage of business rules and boundary conditions
- ✅ Test both happy paths and error scenarios
- ✅ Test boundary values and edge cases

#### 4. **Keep Tests Simple and Focused**
- ✅ Each test should validate one concept or business rule
- ✅ Avoid complex test setups and multiple assertions per test
- ✅ One behavior per test

#### 5. **Use Domain Language in Tests**
- ✅ Use business terminology in test names and assertions
- ✅ Make tests more readable and maintainable
- ✅ Tests serve as living documentation

#### 6. **Arrange-Act-Assert Pattern**
- ✅ Clear structure: Set up test data, execute behavior, verify outcome
- ✅ Makes tests easy to read and understand
- ✅ Consistent pattern across all tests

#### 7. **Test Error Conditions**
- ✅ Verify proper exception handling
- ✅ Test business rule violations
- ✅ Use descriptive error messages

#### 8. **Use Helper Methods for Test Data**
- ✅ Reusable test data creation
- ✅ Reduces test duplication
- ✅ Makes tests more maintainable

#### 9. **Test Business Rules Explicitly**
- ✅ Make business rules visible in tests
- ✅ Test business constraints and validations
- ✅ Document business logic through tests

#### 10. **Use Meaningful Assertions**
- ✅ Specific assertions about expected behavior
- ✅ Test business calculations accurately
- ✅ Verify domain object properties correctly

### Jest Testing Best Practices
- **Helper Functions**: Reusable test data creation
- **Descriptive Names**: Clear test scenario descriptions
- **Specific Assertions**: Testing exact business rule outcomes
- **Scenario Coverage**: Testing different business scenarios

### Benefits of Good Testing Practices
1. **Maintainable**: Tests are easy to understand and modify
2. **Reliable**: Tests provide consistent results
3. **Documentation**: Tests serve as living documentation
4. **Confidence**: Comprehensive coverage builds confidence in changes
5. **Debugging**: Clear test names help identify issues quickly

## Related Concepts

- [Order Tests](./07-order-tests.md) - Examples of good testing practices
- [Money Tests](./08-money-tests.md) - Value object testing examples
- [Customer Service Tests](./10-customer-service-tests.md) - Mocking best practices
- [Testing Anti-Patterns](./11-testing-anti-patterns.md) - What to avoid
- [Unit Testing Benefits](../../1-introduction-to-the-domain.md#benefits-of-ddd-for-unit-testing)

/*
 * Navigation:
 * Previous: 11-testing-anti-patterns.md
 * Next: 13-domain-modeling-best-practices.md
 *
 * Back to: [Best Practices for DDD Unit Testing](../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing)
 */
