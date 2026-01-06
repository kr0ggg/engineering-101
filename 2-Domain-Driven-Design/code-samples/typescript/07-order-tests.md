# Order Tests - TypeScript Example (Jest)

**Section**: [Domain-Driven Design and Unit Testing - Pure Domain Logic](../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable)

**Navigation**: [← Previous: Customer Module](./06-customer-module.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Money Tests →](./08-money-tests.md)

---

```typescript
// TypeScript Example - Order Tests (Jest)
// File: 2-Domain-Driven-Design/code-samples/typescript/07-order-tests.ts

import { Order, OrderId, CustomerId, ProductId, OrderStatus, OrderItem } from './03-order-entity';
import { Money } from './02-money-value-object';

describe('Order Entity', () => {
    let orderId: OrderId;
    let customerId: CustomerId;
    let productId: ProductId;
    let order: Order;

    beforeEach(() => {
        orderId = new OrderId('order-123');
        customerId = new CustomerId('customer-456');
        productId = new ProductId('product-789');
        order = new Order(orderId, customerId);
    });

    describe('Order Creation', () => {
        it('should create order with correct initial state', () => {
            expect(order.id).toBe(orderId);
            expect(order.customerId).toBe(customerId);
            expect(order.status).toBe(OrderStatus.Draft);
            expect(order.items).toHaveLength(0);
            expect(order.totalAmount.equals(Money.zero('USD'))).toBe(true);
            expect(order.itemCount).toBe(0);
        });

        it('should have correct creation date', () => {
            const now = new Date();
            const timeDiff = Math.abs(order.createdAt.getTime() - now.getTime());
            expect(timeDiff).toBeLessThan(1000); // Within 1 second
        });
    });

    describe('Adding Items', () => {
        it('should add item to draft order', () => {
            const unitPrice = Money.fromAmount(25.00, 'USD');
            
            order.addItem(productId, 2, unitPrice);
            
            expect(order.items).toHaveLength(1);
            expect(order.itemCount).toBe(1);
            expect(order.totalAmount.equals(Money.fromAmount(50.00, 'USD'))).toBe(true);
        });

        it('should update quantity when adding existing product', () => {
            const unitPrice = Money.fromAmount(25.00, 'USD');
            
            order.addItem(productId, 2, unitPrice);
            order.addItem(productId, 3, unitPrice);
            
            expect(order.items).toHaveLength(1);
            expect(order.items[0].quantity).toBe(5);
            expect(order.totalAmount.equals(Money.fromAmount(125.00, 'USD'))).toBe(true);
        });

        it('should throw error when adding item to confirmed order', () => {
            const unitPrice = Money.fromAmount(25.00, 'USD');
            
            order.addItem(productId, 2, unitPrice);
            order.confirm();
            
            expect(() => {
                order.addItem(productId, 1, unitPrice);
            }).toThrow('Cannot modify confirmed order');
        });

        it('should throw error for invalid quantity', () => {
            const unitPrice = Money.fromAmount(25.00, 'USD');
            
            expect(() => {
                order.addItem(productId, 0, unitPrice);
            }).toThrow('Quantity must be positive');
            
            expect(() => {
                order.addItem(productId, -1, unitPrice);
            }).toThrow('Quantity must be positive');
        });
    });

    describe('Removing Items', () => {
        beforeEach(() => {
            const unitPrice = Money.fromAmount(25.00, 'USD');
            order.addItem(productId, 2, unitPrice);
        });

        it('should remove item from draft order', () => {
            order.removeItem(productId);
            
            expect(order.items).toHaveLength(0);
            expect(order.totalAmount.equals(Money.zero('USD'))).toBe(true);
        });

        it('should not throw error when removing non-existent item', () => {
            const nonExistentProductId = new ProductId('non-existent');
            
            expect(() => {
                order.removeItem(nonExistentProductId);
            }).not.toThrow();
        });

        it('should throw error when removing item from confirmed order', () => {
            order.confirm();
            
            expect(() => {
                order.removeItem(productId);
            }).toThrow('Cannot modify confirmed order');
        });
    });

    describe('Updating Item Quantity', () => {
        beforeEach(() => {
            const unitPrice = Money.fromAmount(25.00, 'USD');
            order.addItem(productId, 2, unitPrice);
        });

        it('should update item quantity in draft order', () => {
            order.updateItemQuantity(productId, 5);
            
            expect(order.items[0].quantity).toBe(5);
            expect(order.totalAmount.equals(Money.fromAmount(125.00, 'USD'))).toBe(true);
        });

        it('should throw error for invalid quantity', () => {
            expect(() => {
                order.updateItemQuantity(productId, 0);
            }).toThrow('Quantity must be positive');
        });

        it('should throw error when updating confirmed order', () => {
            order.confirm();
            
            expect(() => {
                order.updateItemQuantity(productId, 5);
            }).toThrow('Cannot modify confirmed order');
        });
    });

    describe('Order Confirmation', () => {
        it('should confirm order with items', () => {
            const unitPrice = Money.fromAmount(25.00, 'USD');
            order.addItem(productId, 2, unitPrice);
            
            order.confirm();
            
            expect(order.status).toBe(OrderStatus.Confirmed);
        });

        it('should throw error when confirming empty order', () => {
            expect(() => {
                order.confirm();
            }).toThrow('Cannot confirm empty order');
        });

        it('should throw error when confirming non-draft order', () => {
            const unitPrice = Money.fromAmount(25.00, 'USD');
            order.addItem(productId, 2, unitPrice);
            order.confirm();
            
            expect(() => {
                order.confirm();
            }).toThrow('Order is not in draft status');
        });
    });

    describe('Order Status Transitions', () => {
        beforeEach(() => {
            const unitPrice = Money.fromAmount(25.00, 'USD');
            order.addItem(productId, 2, unitPrice);
            order.confirm();
        });

        it('should transition from confirmed to shipped', () => {
            order.ship();
            expect(order.status).toBe(OrderStatus.Shipped);
        });

        it('should transition from shipped to delivered', () => {
            order.ship();
            order.deliver();
            expect(order.status).toBe(OrderStatus.Delivered);
        });

        it('should allow cancellation before delivery', () => {
            order.cancel();
            expect(order.status).toBe(OrderStatus.Cancelled);
        });

        it('should throw error when shipping non-confirmed order', () => {
            const newOrder = new Order(new OrderId('order-456'), customerId);
            const unitPrice = Money.fromAmount(25.00, 'USD');
            newOrder.addItem(productId, 2, unitPrice);
            
            expect(() => {
                newOrder.ship();
            }).toThrow('Order must be confirmed before shipping');
        });

        it('should throw error when delivering non-shipped order', () => {
            expect(() => {
                order.deliver();
            }).toThrow('Order must be shipped before delivery');
        });

        it('should throw error when cancelling delivered order', () => {
            order.ship();
            order.deliver();
            
            expect(() => {
                order.cancel();
            }).toThrow('Cannot cancel delivered order');
        });
    });

    describe('Business Rules', () => {
        it('should correctly identify modifiable orders', () => {
            expect(order.canBeModified()).toBe(true);
            
            const unitPrice = Money.fromAmount(25.00, 'USD');
            order.addItem(productId, 2, unitPrice);
            order.confirm();
            
            expect(order.canBeModified()).toBe(false);
        });

        it('should correctly identify confirmable orders', () => {
            expect(order.canBeConfirmed()).toBe(false);
            
            const unitPrice = Money.fromAmount(25.00, 'USD');
            order.addItem(productId, 2, unitPrice);
            
            expect(order.canBeConfirmed()).toBe(true);
        });

        it('should correctly identify shippable orders', () => {
            expect(order.canBeShipped()).toBe(false);
            
            const unitPrice = Money.fromAmount(25.00, 'USD');
            order.addItem(productId, 2, unitPrice);
            order.confirm();
            
            expect(order.canBeShipped()).toBe(true);
        });

        it('should correctly identify deliverable orders', () => {
            expect(order.canBeDelivered()).toBe(false);
            
            const unitPrice = Money.fromAmount(25.00, 'USD');
            order.addItem(productId, 2, unitPrice);
            order.confirm();
            order.ship();
            
            expect(order.canBeDelivered()).toBe(true);
        });

        it('should correctly identify cancellable orders', () => {
            expect(order.canBeCancelled()).toBe(true);
            
            const unitPrice = Money.fromAmount(25.00, 'USD');
            order.addItem(productId, 2, unitPrice);
            order.confirm();
            order.ship();
            order.deliver();
            
            expect(order.canBeCancelled()).toBe(false);
        });
    });

    describe('Order Items', () => {
        it('should create order item with correct properties', () => {
            const unitPrice = Money.fromAmount(25.00, 'USD');
            const item = new OrderItem(productId, 2, unitPrice);
            
            expect(item.productId).toBe(productId);
            expect(item.quantity).toBe(2);
            expect(item.unitPrice).toBe(unitPrice);
            expect(item.totalPrice.equals(Money.fromAmount(50.00, 'USD'))).toBe(true);
        });

        it('should throw error for invalid item quantity', () => {
            const unitPrice = Money.fromAmount(25.00, 'USD');
            
            expect(() => {
                new OrderItem(productId, 0, unitPrice);
            }).toThrow('Quantity must be positive');
        });

        it('should correctly compare order items', () => {
            const unitPrice = Money.fromAmount(25.00, 'USD');
            const item1 = new OrderItem(productId, 2, unitPrice);
            const item2 = new OrderItem(productId, 2, unitPrice);
            const item3 = new OrderItem(productId, 3, unitPrice);
            
            expect(item1.equals(item2)).toBe(true);
            expect(item1.equals(item3)).toBe(false);
        });
    });
});
```

## Key Concepts Demonstrated

### Pure Domain Logic Testing
- **No External Dependencies**: Tests run without databases or external services
- **Fast Execution**: Tests run quickly without I/O operations
- **Deterministic Results**: Same inputs always produce same outputs
- **Easy Setup**: Simple object creation and method calls

### Test Categories
1. **Creation Tests**: Order initialization and default state
2. **Item Management**: Adding, removing, and updating items
3. **Status Transitions**: Order state changes and business rules
4. **Business Rules**: Validation of business constraints
5. **Edge Cases**: Error conditions and boundary cases

### Jest Testing Features Used
- **describe/it blocks**: Organized test structure
- **beforeEach**: Test setup and data preparation
- **expect assertions**: Clear and readable assertions
- **Error testing**: Verifying exception handling
- **Async/await**: Modern JavaScript testing patterns

### Testing Best Practices Shown
- **Descriptive Names**: Test names clearly describe the scenario
- **Single Responsibility**: Each test focuses on one behavior
- **Clear Assertions**: Specific assertions about expected outcomes
- **Proper Setup**: Clean arrange phase with test data

## Related Concepts

- [Order Entity](./03-order-entity.md) - The entity being tested
- [Money Tests](./08-money-tests.md) - Testing value objects
- [Customer Service Tests](./10-customer-service-tests.md) - Testing with mocks
- [Unit Testing Best Practices](../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing)

/*
 * Navigation:
 * Previous: 06-customer-module.md
 * Next: 08-money-tests.md
 *
 * Back to: [Domain-Driven Design and Unit Testing - Pure Domain Logic is Easily Testable](../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable)
 */
